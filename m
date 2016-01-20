From: akpm@linux-foundation.org
Subject: [folded-merged]
 ubsan-run-time-undefined-behavior-sanity-checker-fix.patch removed from -mm tree
Date: Wed, 20 Jan 2016 14:36:05 -0800
Message-ID: <56a00bd5.Vpllmlu0FvtHgWTF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbcATWgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:36:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix
has been removed from the -mm tree.  Its filename was
     ubsan-run-time-undefined-behavior-sanity-checker-fix.patch

This patch was dropped because it was folded into ubsan-run-time-undefined-behavior-sanity-checker.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix

fix unused local warning

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/ubsan.c~ubsan-run-time-undefined-behavior-sanity-checker-fix lib/ubsan.c
--- a/lib/ubsan.c~ubsan-run-time-undefined-behavior-sanity-checker-fix
+++ a/lib/ubsan.c
@@ -118,11 +118,11 @@ static u_max get_unsigned_val(struct typ
 static void val_to_string(char *str, size_t size, struct type_descriptor *type,
 	unsigned long value)
 {
-	u_max val = get_unsigned_val(type, value);
