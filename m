From: akpm@linux-foundation.org
Subject: - checkpatch-__weak-is-an-official-attribute.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:37 -0800
Message-ID: <200901072216.n07MGbMl016320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756943AbZAGWQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: __weak is an official attribute
has been removed from the -mm tree.  Its filename was
     checkpatch-__weak-is-an-official-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: __weak is an official attribute
From: Andy Whitcroft <apw@shadowen.org>

Add __weak as an official attribute.  This tends to be used in a location
where the automated attribute detector misses it.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-__weak-is-an-official-attribute scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-__weak-is-an-official-attribute
+++ a/scripts/checkpatch.pl
@@ -116,7 +116,8 @@ our $Attribute	= qr{
 			__(?:mem|cpu|dev|)(?:initdata|init)|
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
-			____cacheline_internodealigned_in_smp
+			____cacheline_internodealigned_in_smp|
+			__weak
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline};
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch

