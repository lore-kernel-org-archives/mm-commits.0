From: akpm@linux-foundation.org
Subject: - reiser4-change-error-code-base.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:24 -0700
Message-ID: <200710212347.l9LNlOJ1000661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726AbXJUXzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: change error code base
has been removed from the -mm tree.  Its filename was
     reiser4-change-error-code-base.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: change error code base
From: Edward Shishkin <edward@namesys.com>

Change REISER4_ERROR_CODE_BASE to 10000 to not overlap real errnos

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/reiser4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiser4/reiser4.h~reiser4-change-error-code-base fs/reiser4/reiser4.h
--- a/fs/reiser4/reiser4.h~reiser4-change-error-code-base
+++ a/fs/reiser4/reiser4.h
@@ -232,7 +232,7 @@ extern const int REISER4_MAGIC_OFFSET;	/
 
 /** Reiser4 specific error codes **/
 
-#define REISER4_ERROR_CODE_BASE 500
+#define REISER4_ERROR_CODE_BASE 10000
 
 /* Neighbor is not available (side neighbor or parent) */
 #define E_NO_NEIGHBOR  (REISER4_ERROR_CODE_BASE)
_

Patches currently in -mm which might be from edward@namesys.com are

origin.patch
reiser4.patch
reiser4-change-error-code-base.patch
reiser4-use-lzo-library-functions.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
git-nfsd-broke-reiser4.patch
