From: akpm@linux-foundation.org
Subject: [merged]
 documentation-kernel-parameterstxt-fix-memmap=-language.patch removed from
 -mm tree
Date: Fri, 07 Feb 2014 12:18:35 -0800
Message-ID: <52f53f9b.+9pxL1N4dnG6K70d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaBGUSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 15:18:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, andiry.xu@gmail.com, rdunlap@infradead.org

Subject: [merged] documentation-kernel-parameterstxt-fix-memmap=-language.patch removed from -mm tree
To: rdunlap@infradead.org,andiry.xu@gmail.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 12:18:35 -0800


The patch titled
     Subject: Documentation/kernel-parameters.txt: fix memmap= language
has been removed from the -mm tree.  Its filename was
     documentation-kernel-parameterstxt-fix-memmap=-language.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: Documentation/kernel-parameters.txt: fix memmap= language

Clean up descriptions of memmap= boot options.

Add periods (full stops), drop commas, change "used" to
"reserved" or "marked".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andiry Xu <andiry.xu@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-fix-memmap=-language Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-fix-memmap=-language
+++ a/Documentation/kernel-parameters.txt
@@ -1726,16 +1726,16 @@ bytes respectively. Such letter suffixes
 			option description.
 
 	memmap=nn[KMG]@ss[KMG]
-			[KNL] Force usage of a specific region of memory
-			Region of memory to be used, from ss to ss+nn.
+			[KNL] Force usage of a specific region of memory.
+			Region of memory to be used is from ss to ss+nn.
 
 	memmap=nn[KMG]#ss[KMG]
 			[KNL,ACPI] Mark specific memory as ACPI data.
-			Region of memory to be used, from ss to ss+nn.
+			Region of memory to be marked is from ss to ss+nn.
 
 	memmap=nn[KMG]$ss[KMG]
 			[KNL,ACPI] Mark specific memory as reserved.
-			Region of memory to be used, from ss to ss+nn.
+			Region of memory to be reserved is from ss to ss+nn.
 			Example: Exclude memory from 0x18690000-0x1869ffff
 			         memmap=64K$0x18690000
 			         or
_

Patches currently in -mm which might be from rdunlap@infradead.org are

origin.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

