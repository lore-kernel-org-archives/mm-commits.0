From: akpm@linux-foundation.org
Subject: + sgi-xp-define-bytes_per_word.patch added to -mm tree
Date: Sun, 08 Jun 2008 17:17:56 -0700
Message-ID: <200806090017.m590Hu95027062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755723AbYFIAR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 20:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com


The patch titled
     sgi-xp: define BYTES_PER_WORD
has been added to the -mm tree.  Its filename is
     sgi-xp-define-bytes_per_word.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: define BYTES_PER_WORD
From: Dean Nelson <dcn@sgi.com>

Add a BYTES_PER_WORD #define.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-define-bytes_per_word drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-define-bytes_per_word
+++ a/drivers/misc/sgi-xp/xp.h
@@ -19,6 +19,9 @@
 #include <asm/sn/types.h>
 #include <asm/sn/bte.h>
 
+/* >>> Add this #define to some linux header file some day. */
+#define BYTES_PER_WORD	sizeof(void *)
+
 #ifdef USE_DBUG_ON
 #define DBUG_ON(condition)	BUG_ON(condition)
 #else
_

Patches currently in -mm which might be from dcn@sgi.com are

sgi-xp-define-is_shub-and-is_uv-macros.patch
sgi-xp-define-xpsalerror-reason-code.patch
sgi-xp-define-bytes_per_word.patch
sgi-xp-support-runtime-selection-of-xp_max_npartitions.patch
sgi-xp-create-a-common-xp_remote_memcpy-function.patch
sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware.patch
sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only.patch
sgi-xp-isolate-xpc_vars-structure-to-sn2-only.patch
sgi-xp-base-xpc_rsvd_pages-timestamp-on-jiffies.patch
sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify.patch
sgi-xp-isolate-activate-irqs-hardware-specific-components.patch
sgi-xp-isolate-additional-sn2-specific-code.patch
sgi-xp-separate-chctl_flags-from-xpcs-notify-irq.patch
sgi-xp-replace-amo_t-typedef-by-struct-amo.patch
sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only.patch
sgi-xp-enable-xpnet-to-handle-more-than-64-partitions.patch
sgi-xp-isolate-remote-copy-buffer-to-sn2-only.patch
sgi-xp-add-_sn2-suffix-to-a-few-variables.patch

