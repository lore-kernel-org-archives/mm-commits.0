From: akpm@linux-foundation.org
Subject: [merged] checkpatch-ignore-__pure-attribute.patch removed from
 -mm tree
Date: Mon, 16 Feb 2015 12:17:05 -0800
Message-ID: <54e25041.v2mo/eGt6JdECY7h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbbBPURl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: ignore __pure $Attribute
has been removed from the -mm tree.  Its filename was
     checkpatch-ignore-__pure-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: ignore __pure $Attribute

Just like "__cold", ignore the __pure gcc attribute macro so pointer
warnings aren't generated for uses like "int * __pure fn(...)"

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-ignore-__pure-attribute scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ignore-__pure-attribute
+++ a/scripts/checkpatch.pl
@@ -278,6 +278,7 @@ our $Attribute	= qr{
 			__noreturn|
 			__used|
 			__cold|
+			__pure|
 			__noclone|
 			__deprecated|
 			__read_mostly|
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

