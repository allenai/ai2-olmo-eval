
local task_utils = import 'task_utils.libsonnet';

local common_kwargs = {
    task_name: "ppl_custom",
    task_kwargs: {
        keep_all_instance_fields_except: ["text", "tokens"],
        detailed_output: true,
    },
    prediction_kwargs: {
        split: "test",
        model_max_length: task_utils.model_max_length,
    }
};

// TODO: refactor catwalk's Perplexity task so that it actually uses the s3 path.
// until then, let the path be present in nfs ($EVAL_DATA_PATH).
local data_dir = "v3_not_deconned/";

local create_task_kwargs(task_names) = [
    {
        task_kwargs: {
            task_rename: "ppl_" + task_name,
            files: [data_dir + "/" + task_name + "/test"]
        }
    }
    for task_name in task_names
];

local task_dicts = create_task_kwargs(
    [
    "m2d2_s2orc_unsplit",
    "m2d2_wikipedia_unsplit",
    "c4_100_domains",
    "pile",
    "ice_fixed",
    "c4_en",
    "mc4",
    "4chan_meta_sep",
    "manosphere_meta_sep",
    "gab",
    "twitterAAE_HELM_fixed",
    "wikitext_103",
    "ptb",
    "redpajama",
    "falcon-refinedweb",
    "dolma-v1_5",
    "dolma_100_subreddits",
    "dolma_100_programing_languages"
    ]
);

{
    task_set: task_utils.create_task_set_from_task_dicts("eval_suite", task_dicts, common_kwargs)
}
