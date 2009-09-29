From: akpm@linux-foundation.org
Subject: [to-be-updated] ecryptfs-depends-on-crypto.patch removed from -mm tree
Date: Mon, 28 Sep 2009 17:18:30 -0700
Message-ID: <200909290018.n8T0IU8X020007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673AbZI2ASh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Sep 2009 20:18:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, tyhicks@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: depends on CRYPTO
has been removed from the -mm tree.  Its filename was
     ecryptfs-depends-on-crypto.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: depends on CRYPTO
From: Randy Dunlap <randy.dunlap@oracle.com>

ecryptfs uses crypto APIs so it should depend on CRYPTO.
Otherwise many build errors occur. [63 lines not pasted]

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/Kconfig~ecryptfs-depends-on-crypto fs/ecryptfs/Kconfig
--- a/fs/ecryptfs/Kconfig~ecryptfs-depends-on-crypto
+++ a/fs/ecryptfs/Kconfig
@@ -1,6 +1,6 @@
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && NET
+	depends on EXPERIMENTAL && KEYS && NET && CRYPTO
 	select CRYPTO_ECB
 	select CRYPTO_CBC
 	help
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
ecryptfs-depends-on-crypto.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
reiser4-export-remove_from_page_cache-fix.patch

