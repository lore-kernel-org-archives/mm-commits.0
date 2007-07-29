From: akpm@linux-foundation.org
Subject: + reiser4-change-error-code-base.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:38:58 -0700
Message-ID: <200707290738.l6T7cwtW014114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844AbXG2HjP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:39:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com, vs@namesys.com


The patch titled
     reiser4: change error code base
has been added to the -mm tree.  Its filename is
     reiser4-change-error-code-base.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

lzo-add-some-missing-casts.patch
reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-extent2tail.patch
reiser4-fix-read_tail.patch
reiser4-fix-unix-file-readpages-filler.patch
reiser4-fix-for-new-aops-patches.patch
git-block-vs-reiser4.patch
reiser4-cryptcompress-misc-fixups.patch
reiser4-change-error-code-base.patch
