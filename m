From: akpm@linux-foundation.org
Subject: + shm-add-memfdh-to-uapi-export-list.patch added to -mm tree
Date: Wed, 03 Sep 2014 15:55:21 -0700
Message-ID: <54079c59.33gey1Zei8LjqmkE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbaICWzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 18:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drysdale@google.com, dh.herrmann@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shm: add memfd.h to UAPI export list
has been added to the -mm tree.  Its filename is
     shm-add-memfdh-to-uapi-export-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shm-add-memfdh-to-uapi-export-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shm-add-memfdh-to-uapi-export-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

shm-add-memfdh-to-uapi-export-list.patch

