From: akpm@linux-foundation.org
Subject: [merged] shm-add-memfdh-to-uapi-export-list.patch removed from
 -mm tree
Date: Fri, 12 Sep 2014 13:13:06 -0700
Message-ID: <541353d2.LNRrT2IkC5tCILGd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaILUNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 16:13:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drysdale@google.com, dh.herrmann@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shm: add memfd.h to UAPI export list
has been removed from the -mm tree.  Its filename was
     shm-add-memfdh-to-uapi-export-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Drysdale <drysdale@google.com>
Subject: shm: add memfd.h to UAPI export list

New header file memfd.h from commit 9183df25fe7b194563db ("shm: add
memfd_create() syscall") should be exported.

Signed-off-by: David Drysdale <drysdale@google.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/uapi/linux/Kbuild~shm-add-memfdh-to-uapi-export-list include/uapi/linux/Kbuild
--- a/include/uapi/linux/Kbuild~shm-add-memfdh-to-uapi-export-list
+++ a/include/uapi/linux/Kbuild
@@ -240,6 +240,7 @@ header-y += matroxfb.h
 header-y += mdio.h
 header-y += media.h
 header-y += mei.h
+header-y += memfd.h
 header-y += mempolicy.h
 header-y += meye.h
 header-y += mic_common.h
_

Patches currently in -mm which might be from drysdale@google.com are

origin.patch

