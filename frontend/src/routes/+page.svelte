<script>
    import { onMount } from 'svelte';
    
    let searchTerm = '';
    let filteredIceCreams = [];

    const ice_cream_list = [
        { id: 1, name: 'Vanilla' , brand: 'Amul', price: 20 , image: 'https://picsum.photos/seed/picsum/200'},
        { id: 2, name: 'Chocolate', brand: 'Amul', price: 30 , image: 'https://picsum.photos/seed/picsum/200'},
        { id: 3, name: 'Strawberry', brand: 'Amul', price: 40 , image: 'https://picsum.photos/seed/picsum/200'},
        { id: 4, name: 'Vanilla', brand: 'Amul', price: 20 , image: 'https://picsum.photos/seed/picsum/200'},
        { id: 5, name: 'Chocolate', brand: 'Amul', price: 30 , image: 'https://picsum.photos/seed/picsum/200'},
        { id: 6, name: 'Strawberry', brand: 'Amul', price: 40 , image: 'https://picsum.photos/seed/picsum/200'},
    ];

    // Filter ice creams based on search term
    function filterIceCreams() {
        filteredIceCreams = iceCreams.filter(iceCream => iceCream.name.toLowerCase().includes(searchTerm.toLowerCase()));
    }

    // Call the filterIceCreams function whenever the search term changes
    $: {
        filterIceCreams();
    }
    let iceCreams = [];

    // Fetch ice cream data from the backend API
    async function fetchIceCreams() {
        iceCreams = await response.json();
    }

    // Call the fetchIceCreams function when the component is mounted
    onMount(fetchIceCreams);
</script>

<h1>Ice Cream List</h1>

<select>
    <option value="all">All</option>
    <option value="vanilla">Vanilla</option>
    <option value="chocolate">Chocolate</option>
    <option value="strawberry">Strawberry</option>
</select>
<input type="text" placeholder="Search..." bind:value={searchTerm} />

{#if ice_cream_list.length === 0}
    <p>No results found.</p>
{:else}
    <ul>
        {#each ice_cream_list as iceCream}
            <li>{iceCream.name}</li>
        {/each}
    </ul>
{/if}
