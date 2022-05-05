let { networkConfig } = require("../helper-hardhat-config");
const fs = require("fs");
const path = require("path");

const data = require("../contractData/lilHackerz");

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  log("----------------------------------------------------");

  const SVGPixels = await deploy("SVGPixels", {
    from: deployer,
    log: true,
    gasLimit: 25000000,
    gasPrice: 40000000000,
  });

  const LilHackerzMetaData = await deploy("LilHackerzMetaData", {
    from: deployer,
    log: true,
    gasLimit: 25000000,
    gasPrice: 40000000000,
  });

  const p0 = `<style>rect {stroke-width: 0;} @keyframes slideRight {0,100% {transform: translateX(0);} 50% {transform: translateX(10px);}} @keyframes slideLeft {0%,100% {transform: translateX(0);} 50% {transform: translateX(-10px);}} @keyframes slideBottom {0%,100% {transform: translateY(0);} 50% {transform: translateY(10px);}} @keyframes slideTop {0%,100% {transform: translateY(0);} 50% {transform: translateY(-10px);}} @keyframes slideSideToSide {0%,    50%,100% {transform: translateX(0);}    25% {transform: translateX(10px);}    75% {transform: translateX(-10px);}} @keyframes slideSideToSideVertical {0%,    50%,100% {transform: translateY(0);}    25% {transform: translateY(10px);}    75% {transform: translateY(-10px);}} @keyframes blink {0%,100% {  opacity: 1;} 50% {  opacity: 0;}}  .c-1 {animation: slideLeft 1s steps(1) infinite alternate;}.c-2 {animation: slideRight 1s steps(1) infinite;}.c-3 {animation: slideSideToSide 4s steps(1) infinite;}.c-4 {animation: slideBottom 1s steps(1) infinite;}.c-5 {animation: slideTop 1s steps(1) infinite;}.c-6 {animation: slideSideToSideVertical 2s steps(1) infinite;}.c-7 {animation: blink 1s steps(1) infinite;} .c-8 {animation: blink 1s steps(1) infinite reverse;}</style>`;
  const p1 = ``;

  const LilHackerz = await deploy("LilHackerz", {
    from: deployer,
    log: true,
    args: [],
    libraries: {
      SVGPixels: SVGPixels.address,
    },
    gasLimit: 25000000,
    gasPrice: 40000000000,
  });
  log(`You have deployed an NFT contract to ${LilHackerz.address}`);

  const lilHackerzMetadataContract = await ethers.getContractFactory(
    "LilHackerzMetaData",
    {}
  );

  const lilHackerzContract = await ethers.getContractFactory("LilHackerz", {
    libraries: {
      SVGPixels: SVGPixels.address,
    },
  });
  const accounts = await hre.ethers.getSigners();
  const signer = accounts[0];
  const lilHackerz = new ethers.Contract(
    LilHackerz.address,
    lilHackerzContract.interface,
    signer
  );
  const networkName = networkConfig[chainId]["name"];

  const lilHackerzMetaData = new ethers.Contract(
    LilHackerzMetaData.address,
    lilHackerzMetadataContract.interface,
    signer
  );

  log(
    `Verify with:\n npx hardhat verify --network ${networkName} ${SVGPixels.address}`
  );
  log(
    `Verify with:\n npx hardhat verify --network ${networkName} ${LilHackerzMetaData.address}`
  );
  log(
    `Verify with:\n npx hardhat verify --network ${networkName} ${LilHackerz.address}`
  );

  log(`Now let's mint some...`);

  await lilHackerz._setMetadataContract(LilHackerzMetaData.address);

  await lilHackerzMetaData._setDescription(data.description);

  await lilHackerzMetaData._setWebBaseLink(data.website_base);

  await lilHackerzMetaData._setSvgParts(p0, p1);

  await lilHackerzMetaData._addHeads(data.heads, data.heads_traits);

  await lilHackerzMetaData._addHairs(data.hairs, data.hairs_traits);

  await lilHackerzMetaData._addEyes(data.eyes, data.eyes_traits);

  await lilHackerzMetaData._addMouths(data.mouths, data.mouths_traits);

  await lilHackerzMetaData._addHats(data.hats, data.hats_traits);

  await lilHackerzMetaData._addAccessories(
    data.accessories,
    data.accessories_traits
  );

  const nbToMint = Math.max(
    data.heads.length,
    data.hairs.length,
    data.eyes.length,
    data.mouths.length,
    data.hats.length,
    data.accessories.length
  );

  for (let i = 0; i < nbToMint; i++) {
    let tx = await lilHackerz.mint();
    await tx.wait(1);
  }

  const rootDir = path.join(__dirname, "..", "contractOutputs", "lilHackerz");

  if (!fs.existsSync(rootDir)) {
    fs.mkdirSync(rootDir, { recursive: true }, (err) => {
      if (err) throw err;
    });
  }

  for (let i = 0; i < nbToMint; i++) {
    const tokenURI = await lilHackerz.tokenURI(i);

    const json = Buffer.from(
      tokenURI.replace("data:application/json;base64,", ""),
      "base64"
    ).toString("binary");

    const { image, name } = JSON.parse(json);

    const _name = name.replace(/\s/g, "");

    const svg = Buffer.from(
      image.replace("data:image/svg+xml;base64,", ""),
      "base64"
    ).toString("binary");

    fs.writeFileSync(`${rootDir}/${_name}.json`, json, "utf-8");
    fs.writeFileSync(`${rootDir}/${_name}.svg`, svg, "utf-8");

    log(`svg generated: ${rootDir}/${_name}.svg`);
  }
};

module.exports.tags = ["all", "lil-hackerz"];
