import React, { useState, useEffect } from 'react'

import { DisplayCampaigns } from '../components';
import { useStateContext } from '../context'

const Home = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [campaigns, setCampaigns] = useState([]);

  const { address, contract, getCampaigns } = useStateContext();

  const fetchCampaigns = async () => {
    setIsLoading(true);
    const data = await getCampaigns();
    setCampaigns(data);
    setIsLoading(false);
  }
 
  useEffect(() => {
    if(contract) fetchCampaigns();
  }, [address, contract]);

  return (
   <div className=''>
    <div className='relative'>
      <img src='https://www.linkpicture.com/q/IMG_0361_1.jpg' alt='OWN' className='w-full h-96 mb-8' />
      <div className="absolute bottom-10 right-10  text-xl text-orange-600">
        <h1>Token: OWN</h1>
        <p>Network: testnet</p>
      </div>
      </div>

      {/* <div 
      className=" bg-cover bg-center h-[50vh] flex justify-center items-center po:h-96" 
      style={{ backgroundImage: "url('https://www.linkpicture.com/q/IMG_0361_1.jpg" }}>
      <h1 className="text-white text-4xl font-bold">My Component</h1>
    </div> */}
    
    
    <DisplayCampaigns 
      title="All Campaigns"
      isLoading={isLoading}
      campaigns={campaigns}
    />
    
    </div>
  )
}

export default Home