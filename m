From: akpm@linux-foundation.org
Subject: + mm-introduce-vm_ops-map_pages-fix.patch added to -mm tree
Date: Tue, 04 Mar 2014 12:01:52 -0800
Message-ID: <53163130.uu4ng2fcUewwAD8I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaCDUBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 15:01:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, kirill@shutemov.name

Subject: + mm-introduce-vm_ops-map_pages-fix.patch added to -mm tree
To: kirill@shutemov.name,kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 12:01:52 -0800


The patch titled
     Subject: mm: documentaton for do_set_pte()
has been added to the -mm tree.  Its filename is
     mm-introduce-vm_ops-map_pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-vm_ops-map_pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-vm_ops-map_pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm: documentaton for do_set_pte()

do_set_pte() now exported to other compilation unit. Let's document
interface.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-introduce-vm_ops-map_pages-fix mm/memory.c
--- a/mm/memory.c~mm-introduce-vm_ops-map_pages-fix
+++ a/mm/memory.c
@@ -3318,7 +3318,21 @@ static int __do_fault(struct vm_area_str
 	return ret;
 }
 
