From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 27 May 2016 14:26:44 -0700
Message-ID: <20160527142644.87509a5edaf9ccd5cd39b832@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_May_2016_14_26_44_-0700_FqACgNBarXl26nfH"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbcE0V0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Fri__27_May_2016_14_26_44_-0700_FqACgNBarXl26nfH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


- late-breaking ocfs2 updates

- random bunch of fixes

19 patches, based on dc03c0f9d12d85286d5e3623aa96d5c2a271b8e6:

Subject: ocfs2: o2hb: add negotiate timer
Subject: ocfs2: o2hb: add NEGO_TIMEOUT message
Subject: ocfs2: o2hb: add NEGOTIATE_APPROVE message
Subject: ocfs2: o2hb: add some user/debug log
Subject: ocfs2: o2hb: don't negotiate if last hb fail
Subject: ocfs2: o2hb: fix hb hung time
Subject: ocfs2: bump up o2cb network protocol version
Subject: direct-io: fix direct write stale data exposure from concurrent bu=
ffered read
Subject: mm: oom: do not reap task if there are live threads in threadgroup
Subject: MAINTAINERS: add kexec_core.c and kexec_file.c
Subject: MAINTAINERS: Kdump maintainers update
Subject: mm: use early_pfn_to_nid in page_ext_init
Subject: mm: use early_pfn_to_nid in register_page_bootmem_info_node
Subject: oom_reaper: close race with exiting task
Subject: mm: thp: avoid false positive VM_BUG_ON_PAGE in page_move_anon_rma=
p()
Subject: mm/cma: silence warnings due to max() usage
Subject: mm/memcontrol.c: fix the margin computation in mem_cgroup_margin()
Subject: mm/memcontrol.c: move comments for get_mctgt_type() to proper posi=
tion
Subject: mm: disable DEFERRED_STRUCT_PAGE_INIT on !NO_BOOTMEM




--Signature=_Fri__27_May_2016_14_26_44_-0700_FqACgNBarXl26nfH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXSLuaAAoJEJxZ78cCqAIHylEP/jKSNnqtwV0+xRKbXktD+VS8
qx3fQY3at6na1Q7ZktI4KDtrGYV2NrO9hmaTdIyFMz4XJHYTmudWMrlXlJCnS3S6
HwrkeasiN5I9zNFNGiA2zQcnr6V1M2LRH4CoRgfd4mhiCMSM+b7lsSFuOUgpLlQC
9+t3Q+ERXNten+ezuhfbOAntmMulkMBvZDaVL8Dk+Kyh6VL8R8PSTfARHsHKH7Tc
8ERDi5R1orhhL78l1Pjz8ivA2UAIa1zeG3we5yhyMh0ldxfSQvx4cYVtnw3bNbnG
QaT4rosDYE29ZFeb0jRJBsWIgYpSNnFPmcdQUWgh2/CtR690p/XP4DQ8WVOkD/pL
CnQ1HCXWY3PJgMvY9dvKF1skPsqK70r+Lmty4A7+U927LrqCJ6yx28cE8o4YonqE
lIQZryUJ6Lrm5sDlZE3qwtOAv8/ELhkdMHHFgLcdRWgb6mpXhUPKVg2r/AI0BOr+
w9nvDhf5CfCNPlfnhuSAyrFr5nJ5tEmBkF/DYZxDcLwhB2vv2VmVLJsAPKrbl1X+
j/7WsocD+DqblHN2BKpjIGz5RbpcJmi/4H0FNzLGuw6DjpHsnjX/EYQ1JQ9Le/6O
IU+TW5M2tSXGeJp58OmiazgfQ2tEyXhINHcZneZjyrkvnZ3mGXmb9jJiI2LuNFLG
7mhIoGnez9+hEgYKTE8v
=sjd6
-----END PGP SIGNATURE-----

--Signature=_Fri__27_May_2016_14_26_44_-0700_FqACgNBarXl26nfH--
