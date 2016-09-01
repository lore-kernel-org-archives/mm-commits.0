From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 1 Sep 2016 16:14:24 -0700
Message-ID: <20160901161424.c884d27002a86d179b346aa1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Sep_2016_16_14_24_-0700_l10Qniujq+vz9pKP"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59819 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750698AbcIAXOc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2016 19:14:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Thu__1_Sep_2016_16_14_24_-0700_l10Qniujq+vz9pKP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

14 fixes, based on 071e31e254e0e0c438eecba3dba1d6e2d0da36c2:

Subject: mm, oom: prevent premature OOM killer invocation for high order re=
quest
Subject: kexec: fix double-free when failing to relocate the purgatory
Subject: kconfig: tinyconfig: provide whole choice blocks to avoid warnings
Subject: lib/test_hash.c: fix warning in two-dimensional array init
Subject: lib/test_hash.c: fix warning in preprocessor symbol evaluation
Subject: mm, vmscan: only allocate and reclaim from zones with pages manage=
d by the buddy allocator
Subject: drivers/scsi/wd719x.c: remove last declaration using DEFINE_PCI_DE=
VICE_TABLE
Subject: treewide: remove references to the now unnecessary DEFINE_PCI_DEVI=
CE_TABLE
Subject: printk/nmi: avoid direct printk()-s from __printk_nmi_flush()
Subject: mm, mempolicy: task->mempolicy must be NULL before dropping final =
reference
Subject: MAINTAINERS: Vladimir has moved
Subject: kernel/fork: fix CLONE_CHILD_CLEARTID regression in nscd
Subject: rapidio/documentation/mport_cdev: add missing parameter description
Subject: rapidio/tsi721: fix incorrect detection of address translation con=
dition




--Signature=_Thu__1_Sep_2016_16_14_24_-0700_l10Qniujq+vz9pKP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXyLZWAAoJEJxZ78cCqAIHPFwP/j7hk+OQ7wzALfQg5D9SoCRa
VgmUSVuW0iH8pOjxvSx7L3pYbgseri0kcr+aIqc3T0OzMRGxYh8SIXxanSyR0/GS
mrwFHQUefqUgA/zf46euWlBuByOAWtTpVGPnMnpIVDDyDeBzWZM3Xl69I8eb1NDZ
FNOCGQmYLWOGDxtFASoS/XMrhcakpvFn2fbfvhpEcbpXMBArBsnwjbiHjoVeiV6l
m80iCDEbsyOIJAnzR1KJoGHKS1LoIgZw6xRSjLpa21x5+Gyxec8cnhvkqKTdaBrc
qMb8TnAMO7fMiZe3oE9LX1g8x1Mliqv6ubs7gZML9xGezACpK0mHeSi2L0rlPoV4
n/DnvUTTiXpNm1z6FLGwPoIbVrz/4ezUyr6k0opK9VbdtxXKUTjJHi/8t1Vwvmjf
Ql15GHHXV7qQ1vyNliVDrQBocT9Hk8rFLQln/6c/Y/NEjErfVcYZxiC51sol3/DR
Nbejpca4otERpKO61rN7VoB7b/LZvhHEPY7JIIy24aBnMmc6ymLHQqVWSkJ6l+5S
Qqa1F6LmRjasB/GRqStiu98WLViI3ZGE/68f3fTBWmI4aLTTRx1vckEI1Tn3687Z
gfKzt72GYfPCgZF1oJGVuQPkfn5Mj/6pn93hfnHzgoniyK1CsjTjKcyDGVdlYpMi
9ZJYgy1rMLJ3RnmsS3NQ
=WRcu
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Sep_2016_16_14_24_-0700_l10Qniujq+vz9pKP--
