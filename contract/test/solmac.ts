import { expect, should } from 'chai';
import { ethers } from 'hardhat';

should();

let solmac: Contract;
let solmacTest: Contract;

before(async () => {
  const factory = await ethers.getContractFactory('Solmac');
  solmac = await factory.deploy();
  await solmac.deployed();

});

describe('solmac test', function () {
  it('solmac set Data', async function () {
    // 0.0
    const hoge = await solmac.functions.setNewData("test", "0x0000000000000000000000000000000000000000", "https://inteface", "https://github");
    await hoge.wait()

    const currentAddress = await solmac.functions.getCurrentVersion("test");
    currentAddress.versionData.major.toNumber().should.equal(0);
    currentAddress.versionData.minor.toNumber().should.equal(0);
    currentAddress.versionData.contractAddress.should.equal("0x0000000000000000000000000000000000000000");
 
    // 0.1
    await solmac.functions.setMinorVersion("test", "0x0000000000000000000000000000000000000001");

    const currentAddress2 = await solmac.functions.getCurrentVersion("test");
    currentAddress2.versionData.major.toNumber().should.equal(0);
    currentAddress2.versionData.minor.toNumber().should.equal(1);
    currentAddress2.versionData.contractAddress.should.equal("0x0000000000000000000000000000000000000001");
    
    // 1.0
    await solmac.functions.setMajorVersion("test", "0x0000000000000000000000000000000000000010", "https://inteface2");

    const currentAddress3 = await solmac.functions.getCurrentVersion("test");
    currentAddress3.versionData.major.toNumber().should.equal(1);
    currentAddress3.versionData.minor.toNumber().should.equal(0);
    currentAddress3.versionData.contractAddress.should.equal("0x0000000000000000000000000000000000000010");

    // 1.1
    await solmac.functions.setMinorVersion("test", "0x0000000000000000000000000000000000000011");
    const currentAddress4 = await solmac.functions.getCurrentVersion("test");
    currentAddress4.versionData.major.toNumber().should.equal(1);
    currentAddress4.versionData.minor.toNumber().should.equal(1);
    currentAddress4.versionData.contractAddress.should.equal("0x0000000000000000000000000000000000000011");

    // 1.2
    await solmac.functions.setMinorVersion("test", "0x0000000000000000000000000000000000000012");
    const currentAddress5 = await solmac.functions.getCurrentVersion("test");
    currentAddress5.versionData.major.toNumber().should.equal(1);
    currentAddress5.versionData.minor.toNumber().should.equal(2);
    currentAddress5.versionData.contractAddress.should.equal("0x0000000000000000000000000000000000000012");

    // end of stored data
  }),
  
  it('solmac set Data', async function () {

    const currentAddress = await solmac.functions.getCurrentVersionByMajor("test", 0);
    currentAddress.versionData.major.toNumber().should.equal(0);
    currentAddress.versionData.minor.toNumber().should.equal(1);
    currentAddress.versionData.contractAddress.should.equal("0x0000000000000000000000000000000000000001");

    const currentAddress2 = await solmac.functions.getCurrentVersionByVersion("test", 0, 0);
    currentAddress2.versionData.major.toNumber().should.equal(0);
    currentAddress2.versionData.minor.toNumber().should.equal(0);
    currentAddress2.versionData.contractAddress.should.equal("0x0000000000000000000000000000000000000000");

    const currentAddress3 = await solmac.functions.getCurrentVersionByMajor("test", 1);
    currentAddress3.versionData.major.toNumber().should.equal(1);
    currentAddress3.versionData.minor.toNumber().should.equal(2);
    currentAddress3.versionData.contractAddress.should.equal("0x0000000000000000000000000000000000000012");

  })

  it('solmac test', async function () {
    // return 1 
    const factory1 = await ethers.getContractFactory('TestContractVersionOne');
    const registeredTestContract1 = await factory1.deploy();
    
    // return 11 
    const factory11 = await ethers.getContractFactory('TestContractVersionOneOne')
    const registeredTestContract11 = await factory11.deploy();
    
    // return 12
    const factory12 = await ethers.getContractFactory('TestContractVersionOneTwo')
    const registeredTestContract12 = await factory12.deploy();

    // return 2
    const factory2 = await ethers.getContractFactory('TestContractVersionTwo')
    const registeredTestContract2 = await factory2.deploy();

    
    // set contract to solmac
    const hoge = await solmac.functions.setNewData("apptest", registeredTestContract1.address, "https://inteface", "https://github");
    await hoge.wait()

    // init solmacTest
    const factory = await ethers.getContractFactory('SolmacTest');
    solmacTest = await factory.deploy(solmac.address);
    await solmacTest.deployed();
    
    // 1
    const getversion = await solmacTest.getVersion();
    getversion.toNumber().should.equal(1)

    // 11
    const hoge2 = await solmac.functions.setMinorVersion("apptest", registeredTestContract11.address);
    await hoge2.wait()

    const getversion2 = await solmacTest.getVersion();
    getversion2.toNumber().should.equal(11);

    // 12
    const hoge3 = await solmac.functions.setMinorVersion("apptest", registeredTestContract12.address);
    await hoge3.wait()

    const getversion3 = await solmacTest.getVersion();
    getversion3.toNumber().should.equal(12);


    // no interface compatibility contract.
    // 2
    try {
      const hoge4 = await solmac.functions.setMinorVersion("apptest", registeredTestContract2.address);
      await hoge4.wait()
      solmacTest.getVersion()
    } catch (e) {
      console.log(e);
    }
    
  })

})
