From: akpm@osdl.org
Subject: + ecryptfs-public-key-transport-mechanism-fix.patch added to -mm tree
Date: Tue, 12 Dec 2006 16:30:38 -0800
Message-ID: <200612130030.kBD0UcFv022525@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33403 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964841AbWLMAg0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 19:36:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     ecryptfs-public-key-transport-mechanism fix
has been added to the -mm tree.  Its filename is
     ecryptfs-public-key-transport-mechanism-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs-public-key-transport-mechanism fix
From: Michael Halcrow <mhalcrow@us.ibm.com>

Add net build dependency to eCryptfs Kconfig entry.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig~ecryptfs-public-key-transport-mechanism-fix fs/Kconfig
--- a/fs/Kconfig~ecryptfs-public-key-transport-mechanism-fix
+++ a/fs/Kconfig
@@ -1101,7 +1101,7 @@ config AFFS_FS
 
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

