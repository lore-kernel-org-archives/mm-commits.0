From: akpm@linux-foundation.org
Subject: - security-introduce-security=-boot-parameter-fix.patch removed from -mm tree
Date: Fri, 07 Mar 2008 15:01:04 -0800
Message-ID: <200803072301.m27N147o021743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402AbYCGXKj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 18:10:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmorris@namei.org, darwish.07@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fix up documentation for security_module_enable
has been removed from the -mm tree.  Its filename was
     security-introduce-security=-boot-parameter-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Subject: fix up documentation for security_module_enable
From: James Morris <jmorris@namei.org>

security_module_enable() can only be called during kernel init.

Signed-off-by: James Morris <jmorris@namei.org>
Cc: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/security.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/security.c~security-introduce-security=-boot-parameter-fix security/security.c
--- a/security/security.c~security-introduce-security=-boot-parameter-fix
+++ a/security/security.c
@@ -83,7 +83,7 @@ __setup("security=", choose_lsm);
  *
  * Each LSM must pass this method before registering its own operations
  * to avoid security registration races. This method may also be used
- * to check if your LSM is currently loaded.
+ * to check if your LSM is currently loaded during kernel initialization.
  *
  * Return true if:
  *	-The passed LSM is the one chosen by user at boot time,
_

Patches currently in -mm which might be from jmorris@namei.org are

origin.patch
git-selinux.patch
git-security-testing.patch
git-unionfs.patch
capabilities-implement-per-process-securebits.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch

