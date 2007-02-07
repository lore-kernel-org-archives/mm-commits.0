From: akpm@linux-foundation.org
Subject: + git-cryptodev-fixup.patch added to -mm tree
Date: Wed, 07 Feb 2007 12:30:10 -0800
Message-ID: <200702072030.l17KUAOQ026299@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35319 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161153AbXBGUaL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 15:30:11 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l17KUAdD018050
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 7 Feb 2007 12:30:10 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-cryptodev-fixup
has been added to the -mm tree.  Its filename is
     git-cryptodev-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-cryptodev-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/Kconfig |    3 ---
 1 files changed, 3 deletions(-)

diff -puN crypto/Kconfig~git-cryptodev-fixup crypto/Kconfig
--- a/crypto/Kconfig~git-cryptodev-fixup
+++ a/crypto/Kconfig
@@ -177,8 +177,6 @@ config CRYPTO_DES
 	help
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
 
-<<<<<<< HEAD/crypto/Kconfig
-=======
 config CRYPTO_DES_S390
 	tristate "DES and Triple DES cipher algorithms (s390)"
 	depends on S390
@@ -194,7 +192,6 @@ config CRYPTO_FCRYPT
 	help
 	  FCrypt algorithm used by RxRPC.
 
->>>>>>> /crypto/Kconfig
 config CRYPTO_BLOWFISH
 	tristate "Blowfish cipher algorithm"
 	select CRYPTO_ALGAPI
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
git-block.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
workqueue-dont-save-interrupts-in-run_workqueue-update.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
git-cryptodev-fixup.patch
