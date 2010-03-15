From: akpm@linux-foundation.org
Subject: [merged] cgroups-fix-contents-in-cgroups-documentation.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:30 -0400
Message-ID: <201003150659.o2F6x41f016502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759695Ab0COG7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix CONTENTS in cgroups documentation
has been removed from the -mm tree.  Its filename was
     cgroups-fix-contents-in-cgroups-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix CONTENTS in cgroups documentation
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Add a forgotten item into CONTENTS.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-fix-contents-in-cgroups-documentation Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-fix-contents-in-cgroups-documentation
+++ a/Documentation/cgroups/cgroups.txt
@@ -22,6 +22,7 @@ CONTENTS:
 2. Usage Examples and Syntax
   2.1 Basic Usage
   2.2 Attaching processes
+  2.3 Mounting hierarchies by name
 3. Kernel API
   3.1 Overview
   3.2 Synchronization
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

