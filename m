From: akpm@linux-foundation.org
Subject: - sgi-xp-define-bytes_per_word.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:21 -0700
Message-ID: <200807301916.m6UJGLUA011118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbYG3TRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: define BYTES_PER_WORD
has been removed from the -mm tree.  Its filename was
     sgi-xp-define-bytes_per_word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

