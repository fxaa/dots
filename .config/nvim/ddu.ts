import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
  Ddu,
  Denops,
} from "jsr:@shougo/ddu-vim@~5.0.0/types";
import { ConfigArguments } from "jsr:@shougo/ddu-vim@~5.0.0/config";
import { ActionData as FileAction } from "jsr:@shougo/ddu-kind-file@~0.8.0";
import { Params as FfParams } from "jsr:@shougo/ddu-ui-ff@~1.2.0";
import { Params as FilerParams } from "jsr:@shougo/ddu-ui-filer@~1.2.0";

import * as fn from "jsr:@denops/std@~7.0.0/function";

type Params = Record<string, unknown>;

type DppAction = {
  path: string;
  __name: string;
};

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.setAlias("files", "source", "file_rg", "file_external");
    args.setAlias("files", "source", "file_git", "file_external");
    args.setAlias("files", "filter", "matcher_ignore_current_buffer", "matcher_ignores");
    args.setAlias("files", "action", "tabopen", "open");

    args.contextBuilder.patchGlobal({
      ui: "ff",
      profile: false,
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_substring"],
          smartCase: true,
        },
        file_old: {
          matchers: [
            "matcher_relative",
            "matcher_substring",
          ],
          converters: ["converter_hl_dir"],
        },
        file_git: {
          matchers: [
            "matcher_relative",
            "matcher_substring",
          ],
          converters: ["converter_hl_dir"],
        },
        file_rec: {
          matchers: [
            "matcher_substring",
            "matcher_hidden",
          ],
          converters: ["converter_hl_dir"],
        },
        file: {
          matchers: [
            "matcher_substring",
            "matcher_hidden",
          ],
          sorters: ["sorter_alpha"],
          converters: ["converter_hl_dir"],
        },
        dpp: {
          defaultAction: "cd",
          actions: {
            update: async (args: ActionArguments<Params>) => {
              const names = args.items.map((item) =>
                (item.action as DppAction).__name
              );

              await args.denops.call(
                "dpp#async_ext_action",
                "installer",
                "update",
                { names },
              );

              return Promise.resolve(ActionFlags.None);
            },
          },
        },
        command_args: {
          defaultAction: "execute",
        },
        markdown: {
          sorters: [],
        },
        line: {
          matchers: [],
        },
        path_history: {
          defaultAction: "uiCd",
        },
        rg: {
          matchers: [
            "matcher_substring",
            "matcher_files",
          ],
          sorters: ["sorter_alpha"],
        },
      },
      sourceParams: {
        file_git: {
          cmd: ["git", "ls-files", "-co", "--exclude-standard"],
        },
        rg: {
          args: [
            "--ignore-case",
            "--column",
            "--no-heading",
            "--color",
            "never",
          ],
        },
        file_rg: {
          cmd: [
            "rg",
            "--files",
            "--glob",
            "!.git",
            "--color",
            "never",
            "--no-messages",
          ],
          updateItems: 50000,
        },
      },
      filterParams: {
        matcher_substring: {
          highlightMatched: "Search",
        },
        matcher_ignore_files: {
          ignoreGlobs: ["test_*.vim"],
          ignorePatterns: [],
        },
        converter_hl_dir: {
          hlGroup: ["Directory", "Keyword"],
        },
      },
      kindOptions: {
        file: {
          defaultAction: "open",
          actions: {
            grep: async (args: ActionArguments<Params>) => {
              const action = args.items[0]?.action as FileAction;

              await args.denops.call("ddu#start", {
                name: args.options.name,
                push: true,
                sources: [
                  {
                    name: "rg",
                    params: {
                      path: action.path,
                      input: await fn.input(args.denops, "Pattern: "),
                    },
                  },
                ],
              });

              return Promise.resolve(ActionFlags.None);
            },
          },
        },
        word: {
          defaultAction: "append",
        },
        deol: {
          defaultAction: "switch",
        },
        action: {
          defaultAction: "do",
        },
        readme_viewer: {
          defaultAction: "open",
        },
        url: {
          defaultAction: "browse",
        },
      },
      kindParams: {},
      actionOptions: {
        narrow: {
          quit: false,
        },
        tabopen: {
          quit: false,
        },
      },
    });

    return Promise.resolve();
  }
}
