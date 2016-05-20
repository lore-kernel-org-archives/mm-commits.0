From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-uuid-introduce-few-more-generic-helpers-for-uuid-fix.patch removed from -mm tree
Date: Fri, 20 May 2016 16:44:54 -0700
Message-ID: <573fa176.w1b5kyl+ktRQBcCW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbcETXo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:44:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-uuid-introduce-few-more-generic-helpers-for-uuid fix
has been removed from the -mm tree.  Its filename was
     lib-uuid-introduce-few-more-generic-helpers-for-uuid-fix.patch

This patch was dropped because it was folded into lib-uuid-introduce-few-more-generic-helpers-for-uuid.patch

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib-uuid-introduce-few-more-generic-helpers-for-uuid fix

Fix typo.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/uuid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/uuid.c~lib-uuid-introduce-few-more-generic-helpers-for-uuid-fix lib/uuid.c
--- a/lib/uuid.c~lib-uuid-introduce-few-more-generic-helpers-for-uuid-fix
+++ a/lib/uuid.c
@@ -106,7 +106,7 @@ static int __uuid_to_bin(const char *uui
 	static const u8 si[16] = {0,2,4,6,9,11,14,16,19,21,24,26,28,30,32,34};
 	unsigned int i;
 
-	if (uuid_is_valid(uuid))
+	if (!uuid_is_valid(uuid))
 		return -EINVAL;
 
 	for (i = 0; i < 16; i++) {
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-vsprintf-simplify-uuid-printing.patch
ima-use-%pu-to-output-uuid-in-printable-format.patch
lib-uuid-move-generate_random_uuid-to-uuidc.patch
lib-uuid-introduce-few-more-generic-helpers-for-uuid.patch
lib-uuid-remove-fsf-address.patch
sysctl-use-generic-uuid-library.patch
efi-redefine-type-constant-macro-from-generic-code.patch
efivars-use-generic-uuid-library.patch
genhd-move-to-use-generic-uuid-library.patch
ldm-use-generic-uuid-library.patch
wmi-use-generic-uuid-library.patch

