import React from 'react';
import { useNavigate } from 'react-router-dom';

import FundCard from './FundCard';
import { loader } from '../assets';

const DisplayCampaigns = ({ title, isLoading, campaigns }) => {
  const navigate = useNavigate();

  const handleNavigate = (campaign) => {
    navigate(`/campaign-details/${campaign.title}`, { state: campaign })
  }


  return (
    <div>
      <div onClick={() => handleNavigate(campaigns[0])} className='cursor-pointer'>
      <img src='https://www.linkpicture.com/q/IMG_0361_1.jpg' alt='OWN' className='w-full h-96 mb-8'   /></div>
      <h1 className="font-epilogue font-semibold text-[18px] text-white text-left">{title} ({campaigns.length})</h1>

      <div className="flex flex-wrap mt-[20px] gap-[26px]">
        {isLoading && (
          <img src={loader} alt="loader" className="w-[100px] h-[100px] object-contain" />
        )}

        {!isLoading && campaigns.length === 0 && (
          <p className="font-epilogue font-semibold text-[14px] leading-[30px] text-[#818183]">
            You have not created any campigns yet
          </p>
        )}

        {!isLoading && campaigns.length > 0 && campaigns.slice(1).map((campaign) => (
  <FundCard 
    key={campaign.id}
    {...campaign}
    handleClick={() => handleNavigate(campaign)}
  />
))}
      </div>
    </div>
  )
}

export default DisplayCampaigns