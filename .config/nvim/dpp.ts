import {
  BaseConfig,
  type ConfigReturn,
  type ContextBuilder,
  type Dpp,
  type ExtOptions,
  type MultipleHook,
  type Plugin,
} from "jsr:@shougo/dpp-vim@~2.2.0/types";
import { mergeFtplugins } from "jsr:@shougo/dpp-vim@~2.2.0/utils";

import type {
  Ext as LazyExt,
  Params as LazyParams,
  LazyMakeStateResult,
} from "jsr:@shougo/dpp-ext-lazy@~1.4.0";
import type {
  Ext as LocalExt,
  Params as LocalParams,
} from "jsr:@shougo/dpp-ext-local@~1.2.0";
import type {
  Ext as PackspecExt,
  Params as PackspecParams,
} from "jsr:@shougo/dpp-ext-packspec@~1.2.0";
import type {
  Ext as TomlExt,
  Params as TomlParams,
} from "jsr:@shougo/dpp-ext-toml@~1.1.0";

import type { Denops } from "jsr:@denops/std@~7.0.1";
import * as fn from "jsr:@denops/std@~7.0.1/function";

import { expandGlob } from "jsr:@std/fs@~1.0.0/expand-glob";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    const hasNvim = args.denops.meta.host === "nvim";
    const hasWindows = await fn.has(args.denops, "win32");

    const inlineVimrcs = [
      "$BASE_DIR/options.rc.vim",
      "$BASE_DIR/mappings.rc.vim",
      "$BASE_DIR/filetype.rc.vim",
    ];

    if (hasNvim) {
      inlineVimrcs.push("$BASE_DIR/neovim.rc.vim");
    } 

    // set global context & use inline vimrcs
    args.contextBuilder.setGlobal({
      inlineVimrcs,
      extParams: {
        installer: {
          checkDiff: true,
          logFilePath: "~/.cache/dpp/installer-log.txt",
          githubAPIToken: Deno.env.get("GITHUB_API_TOKEN"),
        },
      },
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const protocols = await args.dpp.getProtocols(args.denops, options);

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
    let multipleHooks: MultipleHook[] = [];

    const [tomlExt, tomlOptions, tomlParams]: [
      TomlExt | undefined,
      ExtOptions,
      TomlParams,
    ] = await args.dpp.getExt(
      args.denops,
      options,
      "toml",
    ) as [TomlExt | undefined, ExtOptions, TomlParams];
    if (tomlExt) {
      const action = tomlExt.actions.load;

      const tomlPromises = [
        { path: "$BASE_DIR/merge.toml", lazy: false },
        { path: "$BASE_DIR/dpp.toml", lazy: false },
        { path: "$BASE_DIR/lazy.toml", lazy: true },
        { path: "$BASE_DIR/ddc.toml", lazy: true },
        { path: "$BASE_DIR/denops.toml", lazy: true },
        { path: "$BASE_DIR/ddu.toml", lazy: true },
        { path: "$BASE_DIR/ddx.toml", lazy: true },
	...(hasNvim ? [{
		path: "$BASE_DIR/neovim.toml",
		lazy: true,
	}] : [] ),
      ].map((tomlFile) =>
        action.callback({
          denops: args.denops,
          context,
          options,
          protocols,
          extOptions: tomlOptions,
          extParams: tomlParams,
          actionParams: {
            path: tomlFile.path,
            options: {
              lazy: tomlFile.lazy,
            },
          },
        })
      );

      const tomls = await Promise.all(tomlPromises);

      // Merge toml results
      for (const toml of tomls) {
        for (const plugin of toml.plugins ?? []) {
          recordPlugins[plugin.name] = plugin;
        }

        if (toml.ftplugins) {
          mergeFtplugins(ftplugins, toml.ftplugins);
        }

        if (toml.multiple_hooks) {
          multipleHooks = multipleHooks.concat(toml.multiple_hooks);
        }

        if (toml.hooks_file) {
          hooksFiles.push(toml.hooks_file);
        }
      }
    }

    const [localExt, localOptions, localParams]: [
      LocalExt | undefined,
      ExtOptions,
      LocalParams,
    ] = await args.dpp.getExt(
      args.denops,
      options,
      "local",
    ) as [LocalExt | undefined, ExtOptions, LocalParams];
    if (localExt) {
      const action = localExt.actions.local;

      const localPlugins = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: localOptions,
        extParams: localParams,
        actionParams: {
          directory: "~/.config/nvim/custom",
          options: {
            frozen: true,
            merged: false,
          },
          includes: [
            "vim*",
            "nvim-*",
            "*.vim",
            "*.nvim",
            "ddc-*",
            "ddu-*",
            "dpp-*",
          ],
        },
      });

      for (const plugin of localPlugins) {
        if (plugin.name in recordPlugins) {
          recordPlugins[plugin.name] = Object.assign(
            recordPlugins[plugin.name],
            plugin,
          );
        } else {
          recordPlugins[plugin.name] = plugin;
        }
      }
    }

    const [packspecExt, packspecOptions, packspecParams]: [
      PackspecExt | undefined,
      ExtOptions,
      PackspecParams,
    ] = await args.dpp
      .getExt(
        args.denops,
        options,
        "packspec",
      ) as [PackspecExt | undefined, ExtOptions, PackspecParams];
    if (packspecExt) {
      const action = packspecExt.actions.load;

      const packSpecPlugins = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: packspecOptions,
        extParams: packspecParams,
        actionParams: {
          basePath: args.basePath,
          plugins: Object.values(recordPlugins),
        },
      });

      for (const plugin of packSpecPlugins) {
        if (plugin.name in recordPlugins) {
          recordPlugins[plugin.name] = Object.assign(
            recordPlugins[plugin.name],
            plugin,
          );
        } else {
          recordPlugins[plugin.name] = plugin;
        }
      }
      //console.log(packSpecPlugins);
    }

    const [lazyExt, lazyOptions, lazyParams]: [
      LazyExt | undefined,
      ExtOptions,
      LazyParams,
    ] = await args.dpp.getExt(
      args.denops,
      options,
      "lazy",
    ) as [LazyExt | undefined, ExtOptions, PackspecParams];
    let lazyResult: LazyMakeStateResult | undefined = undefined;
    if (lazyExt) {
      const action = lazyExt.actions.makeState;

      lazyResult = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: lazyOptions,
        extParams: lazyParams,
        actionParams: {
          plugins: Object.values(recordPlugins),
        },
      });
    }

    const checkFiles = [];
    for await (const file of expandGlob(`${Deno.env.get("BASE_DIR")}/*`)) {
      checkFiles.push(file.path);
    }

    return {
      checkFiles,
      ftplugins,
      hooksFiles,
      multipleHooks,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
