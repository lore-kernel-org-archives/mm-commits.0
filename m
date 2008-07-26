From: akpm@linux-foundation.org
Subject: - video-console-sticonrec-make-code-static-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 25 Jul 2008 17:06:17 -0700
Message-ID: <200807260006.m6Q06Hvf006562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbYGZAGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 20:06:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     video-console-sticonrec-make-code-static-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     video-console-sticonrec-make-code-static-checkpatch-fixes.patch

This patch was dropped because it was folded into video-console-sticonrec-make-code-static.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video-console-sticonrec-make-code-static-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required after that ',' (ctx:OxV)
#107: FILE: drivers/video/console/sticore.c:544:
+		 int (*search_font_fnc) (struct sti_cooked_rom *,int,int) )
 		                                                ^

ERROR: space required after that ',' (ctx:VxV)
#107: FILE: drivers/video/console/sticore.c:544:
+		 int (*search_font_fnc) (struct sti_cooked_rom *,int,int) )
 		                                                    ^

ERROR: space prohibited before that close parenthesis ')'
#107: FILE: drivers/video/console/sticore.c:544:
+		 int (*search_font_fnc) (struct sti_cooked_rom *,int,int) )

total: 3 errors, 0 warnings, 102 lines checked

./patches/video-console-sticonrec-make-code-static.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/sticore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/sticore.c~video-console-sticonrec-make-code-static-checkpatch-fixes drivers/video/console/sticore.c
--- a/drivers/video/console/sticore.c~video-console-sticonrec-make-code-static-checkpatch-fixes
+++ a/drivers/video/console/sticore.c
@@ -541,7 +541,7 @@ static struct sti_cooked_font __devinit
 
 static struct sti_cooked_font __devinit
 *sti_select_font(struct sti_cooked_rom *rom,
-		 int (*search_font_fnc) (struct sti_cooked_rom *,int,int) )
+		 int (*search_font_fnc)(struct sti_cooked_rom *, int, int))
 {
 	struct sti_cooked_font *font;
 	int i;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
tpm-increase-size-of-internal-tpm-response-buffers.patch
memstick-allow-set_param-method-to-return-an-error-code.patch
memstick-use-fully-asynchronous-request-processing.patch
full-conversion-to-early_initcall-interface-remove-old-interface.patch
mm-introduce-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast.patch
mm-speculative-page-references.patch
slb-drop-kmem-cache-argument-from-constructor.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch

