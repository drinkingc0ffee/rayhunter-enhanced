<script lang="ts">
    import { ManifestEntry } from "$lib/manifest.svelte";
    import DownloadLink from '$lib/components/DownloadLink.svelte';
    import DeleteButton from "$lib/components/DeleteButton.svelte";
    import AnalysisStatus from "./AnalysisStatus.svelte";
    import AnalysisView from "./AnalysisView.svelte";
    import RecordingControls from "./RecordingControls.svelte";
    let { entry, current, i, server_is_recording }: {
        entry: ManifestEntry;
        current: boolean;
        i: number;
        server_is_recording: boolean;
    } = $props();

    // passing `undefined` as the locale uses the browser default
    const date_formatter = new Intl.DateTimeFormat(undefined, {
        timeStyle: "long",
        dateStyle: "short",
    });
    let status_row_color = $derived.by(() => {
        const num_warnings = entry.get_num_warnings();
        if (num_warnings !== undefined && num_warnings > 0) {
            return "bg-red-100";
        }
        return current ? "bg-green-100" : "bg-gray-100"
    });
    let status_border_color = $derived.by(() => {
        const num_warnings = entry.get_num_warnings();
        if (num_warnings !== undefined && num_warnings > 0) {
            return "border-red-100";
        }
        return current ? "border-green-100" : "border-gray-100"
    });
    let analysis_visible = $state(false);
    function toggle_analysis_visibility() {
        analysis_visible = !analysis_visible;
    }

    let has_gps = $state(false);
    
    // Check if GPS file exists
    $effect(() => {
        entry.has_gps_file().then(exists => {
            has_gps = exists;
        });
    });
</script>
<div class="{status_row_color} {status_border_color} drop-shadow p-4 flex flex-col gap-2 border rounded-md flex-1">
    {#if current}
        <div class="flex flex-row justify-between gap-2">
            <span class="text-xl mb-2">Current Recording</span>
            <span class=""><AnalysisStatus onclick={toggle_analysis_visibility} entry={entry} analysis_visible={analysis_visible}/></span>
        </div>
    {/if}
    <div class="flex flex-col">
        <div class="flex flex-row justify-between">
            <span class="font-bold">ID: {entry.name}</span>
            {#if !current}
                <span class=""><AnalysisStatus onclick={toggle_analysis_visibility} entry={entry} analysis_visible={analysis_visible}/></span>
            {/if}
        </div>
        <span class="">{entry.get_readable_qmdl_size()}</span>
    </div>
    <div class="flex flex-col">
        <span class="">Start: {date_formatter.format(entry.start_time)}</span>
        <span class="">Last Message: {entry.last_message_time && date_formatter.format(entry.last_message_time) || "N/A"}</span>
    </div>
    <div class="flex flex-row justify-between lg:justify-end gap-2 mt-2">
        <DownloadLink url={entry.get_pcap_url()} text="pcap" full_button=true />
        <DownloadLink url={entry.get_qmdl_url()} text="qmdl" full_button=true />
        <DownloadLink url={entry.get_zip_url()} text="zip" full_button=true />
        {#if has_gps}
            <DownloadLink url={entry.get_gps_url()} text="gps" full_button=true />
        {/if}
        {#if current}
            <RecordingControls {server_is_recording} />
        {:else}
            <DeleteButton
                prompt={`Are you sure you want to delete entry ${entry.name}?`}
                url={entry.get_delete_url()}
            />
        {/if}
    </div>
    <div class="border-b {analysis_visible ? '' : 'hidden'}">
        <AnalysisView {entry} />
    </div>
</div>
