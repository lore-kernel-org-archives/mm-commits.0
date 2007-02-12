From: akpm@linux-foundation.org
Subject: - ecryptfs-public-key-transport-mechanism-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:24:32 -0800
Message-ID: <200702120724.l1C7OW1g024751@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45223 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964780AbXBLHjz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:39:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs-public-key-transport-mechanism fix
has been removed from the -mm tree.  Its filename was
     ecryptfs-public-key-transport-mechanism-fix.patch

This patch was dropped because it was folded into ecryptfs-public-key-transport-mechanism.patch

------------------------------------------------------
Subject: ecryptfs-public-key-transport-mechanism fix
From: Michael Halcrow <mhalcrow@us.ibm.com>

Add net build dependency to eCryptfs Kconfig entry.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig~ecryptfs-public-key-transport-mechanism-fix fs/Kconfig
--- a/fs/Kconfig~ecryptfs-public-key-transport-mechanism-fix
+++ a/fs/Kconfig
@@ -1088,7 +1088,7 @@ config AFFS_FS
 
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && CRYPTO
+	depends on EXPERIMENTAL && KEYS && CRYPTO && NET
 	help
 	  Encrypted filesystem that operates on the VFS layer.  See
 	  <file:Documentation/ecryptfs.txt> to learn more about
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-transport-mechanism-fix.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-xattr-flags-and-mount-options.patch
ecryptfs-generalize-metadata-read-write.patch
ecryptfs-generalize-metadata-read-write-fix.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
ecryptfs-encrypted-passthrough.patch
ecryptfs-convert-f_op-write-to-vfs_write.patch
ecryptfs-convert-kmap-to-kmap_atomic.patch
ecryptfs-open-code-flag-checking-and-manipulation.patch
ecryptfs-add-flush_dcache_page-calls.patch
ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch
