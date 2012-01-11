From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-encrypted-keys-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:26 -0800
Message-ID: <20120111212926.9A69210004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:40669 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156Ab2AKV31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:27 -0500
Received: by mail-yw0-f74.google.com with SMTP id p56so153995yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update encrypted-keys F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-encrypted-keys-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update encrypted-keys F: patterns

commit 61cf45d0199 ("encrypted-keys: create encrypted-keys directory")
moved the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-encrypted-keys-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-encrypted-keys-f-patterns
+++ a/MAINTAINERS
@@ -3856,8 +3856,7 @@ L:	keyrings@linux-nfs.org
 S:	Supported
 F:	Documentation/security/keys-trusted-encrypted.txt
 F:	include/keys/encrypted-type.h
-F:	security/keys/encrypted.c
-F:	security/keys/encrypted.h
+F:	security/keys/encrypted-keys/
 
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch

