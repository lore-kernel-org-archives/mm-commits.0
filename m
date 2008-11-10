From: akpm@linux-foundation.org
Subject: - mutex-improve-header-comment-to-be-actually-informative-about-the-api.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:07 -0800
Message-ID: <200811102034.mAAKY71A024870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496AbYKJUeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     mutex: improve header comment to be actually informative about the API
has been removed from the -mm tree.  Its filename was
     mutex-improve-header-comment-to-be-actually-informative-about-the-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mutex: improve header comment to be actually informative about the API
From: Arjan van de Ven <arjan@linux.intel.com>

It's nice to say that mutex_trylock follows the spin_trylock convention. 
It's a lot nicer if the comment also says which that is...  make it so.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mutex.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mutex.h~mutex-improve-header-comment-to-be-actually-informative-about-the-api include/linux/mutex.h
--- a/include/linux/mutex.h~mutex-improve-header-comment-to-be-actually-informative-about-the-api
+++ a/include/linux/mutex.h
@@ -144,6 +144,8 @@ extern int __must_check mutex_lock_killa
 /*
  * NOTE: mutex_trylock() follows the spin_trylock() convention,
  *       not the down_trylock() convention!
+ *
+ * Returns 1 if the mutex has been acquired successfully, and 0 on contention.
  */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
scripts-improve-the-decodecode-script.patch
pci-uninline-pci_ioremap_bar.patch
pci-use-pci_ioremap_bar-in-drivers-misc.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
pci-use-pci_ioremap_bar-in-drivers-video.patch
pci-use-pci_ioremap_bar-in-drivers-edac.patch

