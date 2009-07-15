From: akpm@linux-foundation.org
Subject: + dynamic-debug-fix-typo.patch added to -mm tree
Date: Wed, 15 Jul 2009 12:30:39 -0700
Message-ID: <200907151930.n6FJUdKO019096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132AbZGOTbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 15:31:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, gnb@sgi.com, gregkh@suse.de, jbaron@redhat.com


The patch titled
     Dynamic debug: fix typo: -/->
has been added to the -mm tree.  Its filename is
     dynamic-debug-fix-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Dynamic debug: fix typo: -/->
From: Roel Kluin <roel.kluin@gmail.com>

The member was intended, not the local variable.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Greg Banks <gnb@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/dynamic_debug.c~dynamic-debug-fix-typo lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic-debug-fix-typo
+++ a/lib/dynamic_debug.c
@@ -164,7 +164,7 @@ static void ddebug_change(const struct d
 
 			if (!newflags)
 				dt->num_enabled--;
-			else if (!dp-flags)
+			else if (!dp->flags)
 				dt->num_enabled++;
 			dp->flags = newflags;
 			if (newflags) {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-usb-host-xhci-dbgc-less-and-greater-than-confusion.patch
dynamic-debug-fix-typo.patch
drivers-gpu-drm-ttm-ttm_bo_vmc-fix-misplaced-parentheses.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch

