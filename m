From: akpm@linux-foundation.org
Subject: + mm-memblock-typo-fixed.patch added to -mm tree
Date: Mon, 24 Aug 2015 13:08:38 -0700
Message-ID: <55db79c6.Iv5LSPEjJaC/ibv5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbbHXUIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 16:08:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: fiy typos in comments
has been added to the -mm tree.  Its filename is
     mm-memblock-typo-fixed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-typo-fixed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-typo-fixed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock.c: fiy typos in comments

s/succees/success/

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memblock.c~mm-memblock-typo-fixed mm/memblock.c
--- a/mm/memblock.c~mm-memblock-typo-fixed
+++ a/mm/memblock.c
@@ -762,7 +762,7 @@ int __init_memblock memblock_reserve(phy
  *
  * This function isolates region [@base, @base + @size), and sets/clears flag
  *
- * Return 0 on succees, -errno on failure.
+ * Return 0 on success, -errno on failure.
  */
 static int __init_memblock memblock_setclr_flag(phys_addr_t base,
 				phys_addr_t size, int set, int flag)
@@ -789,7 +789,7 @@ static int __init_memblock memblock_setc
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * Return 0 on succees, -errno on failure.
+ * Return 0 on success, -errno on failure.
  */
 int __init_memblock memblock_mark_hotplug(phys_addr_t base, phys_addr_t size)
 {
@@ -801,7 +801,7 @@ int __init_memblock memblock_mark_hotplu
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * Return 0 on succees, -errno on failure.
+ * Return 0 on success, -errno on failure.
  */
 int __init_memblock memblock_clear_hotplug(phys_addr_t base, phys_addr_t size)
 {
@@ -813,7 +813,7 @@ int __init_memblock memblock_clear_hotpl
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * Return 0 on succees, -errno on failure.
+ * Return 0 on success, -errno on failure.
  */
 int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t size)
 {
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

sh-use-pfn_down-macro.patch
mm-memblock-rename-local-variable-of-memblock_type-to-type.patch
mm-memblock-typo-fixed.patch

