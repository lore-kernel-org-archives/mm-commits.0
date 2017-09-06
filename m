From: akpm@linux-foundation.org
Subject: [folded-merged] mmfork-introduce-madv_wipeonfork-fix.patch
 removed from -mm tree
Date: Wed, 06 Sep 2017 16:12:07 -0700
Message-ID: <59b080c7.dOvhO4/WugvfVzo2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47922 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753615AbdIFXMI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deller@gmx.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmfork-introduce-madv_wipeonfork-fix
has been removed from the -mm tree.  Its filename was
     mmfork-introduce-madv_wipeonfork-fix.patch

This patch was dropped because it was folded into mmfork-introduce-madv_wipeonfork.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmfork-introduce-madv_wipeonfork-fix

numerically order arch/parisc/include/uapi/asm/mman.h #defines

Cc: Helge Deller <deller@gmx.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/uapi/asm/mman.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/parisc/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork-fix arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork-fix
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -57,12 +57,12 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
 
-#define MADV_HWPOISON     100		/* poison a page for testing */
-#define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */
