From: akpm@linux-foundation.org
Subject: [folded-merged] docs-vm-transhuge-fix-few-trivial-typos-fix.patch removed from -mm tree
Date: Mon, 08 May 2017 15:41:29 -0700
Message-ID: <5910f419.Goaq7vIUnsF/ALJG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43568 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdEHWla (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, rdunlap@infradead.org, sj38.park@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: docs-vm-transhuge-fix-few-trivial-typos-fix
has been removed from the -mm tree.  Its filename was
     docs-vm-transhuge-fix-few-trivial-typos-fix.patch

This patch was dropped because it was folded into docs-vm-transhuge-fix-few-trivial-typos.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-vm-transhuge-fix-few-trivial-typos-fix

fixes per Randy

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/vm/transhuge.txt~docs-vm-transhuge-fix-few-trivial-typos-fix Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~docs-vm-transhuge-fix-few-trivial-typos-fix
+++ a/Documentation/vm/transhuge.txt
@@ -520,7 +520,7 @@ comes. Splitting will free up unused sub
 Splitting the page right away is not an option due to locking context in
 the place where we can detect partial unmap. It's also might be
 counterproductive since in many cases partial unmap happens during exit(2) if
-an THP crosses VMA boundary.
+a THP crosses a VMA boundary.
 
 Function deferred_split_huge_page() is used to queue page for splitting.
 The splitting itself will happen when we get memory pressure via shrinker
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos.patch
dax-add-tracepoint-to-dax_writeback_one-fix.patch
drivers-staging-ccree-ssi_hashc-fix-build-with-gcc-444.patch

