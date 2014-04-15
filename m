From: akpm@linux-foundation.org
Subject: + mm-fix-config_debug_vm_rb-description.patch added to -mm tree
Date: Tue, 15 Apr 2014 13:52:19 -0700
Message-ID: <534d9c03.Qy8f6w5s05iL3860%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDOUwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 16:52:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aswin@hp.com, davidlohr@hp.com

Subject: + mm-fix-config_debug_vm_rb-description.patch added to -mm tree
To: davidlohr@hp.com,aswin@hp.com
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 13:52:19 -0700


The patch titled
     Subject: mm: fix CONFIG_DEBUG_VM_RB description
has been added to the -mm tree.  Its filename is
     mm-fix-config_debug_vm_rb-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-config_debug_vm_rb-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-config_debug_vm_rb-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm: fix CONFIG_DEBUG_VM_RB description

This appears to be a copy/paste error.  Update the description to reflect
extra rbtree debug and checks for the config option instead of duplicating
CONFIG_DEBUG_VM.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~mm-fix-config_debug_vm_rb-description lib/Kconfig.debug
--- a/lib/Kconfig.debug~mm-fix-config_debug_vm_rb-description
+++ a/lib/Kconfig.debug
@@ -505,8 +505,7 @@ config DEBUG_VM_RB
 	bool "Debug VM red-black trees"
 	depends on DEBUG_VM
 	help
-	  Enable this to turn on more extended checks in the virtual-memory
-	  system that may impact performance.
+	  Enable VM red-black tree debugging information and extra validations.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from davidlohr@hp.com are

mm-fix-config_debug_vm_rb-description.patch
mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
ipc-constify-ipc_ops.patch

