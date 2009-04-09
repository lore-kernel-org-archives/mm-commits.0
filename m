From: akpm@linux-foundation.org
Subject: + mm-point-the-unevictable_lru-config-option-at-the-documentation.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:07:27 -0700
Message-ID: <200904092207.n39M7Rgn019710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbZDIWKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:10:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     mm: point the UNEVICTABLE_LRU config option at the documentation
has been added to the -mm tree.  Its filename is
     mm-point-the-unevictable_lru-config-option-at-the-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: point the UNEVICTABLE_LRU config option at the documentation
From: David Howells <dhowells@redhat.com>

Point the UNEVICTABLE_LRU config option at the documentation describing
the option.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/Kconfig~mm-point-the-unevictable_lru-config-option-at-the-documentation mm/Kconfig
--- a/mm/Kconfig~mm-point-the-unevictable_lru-config-option-at-the-documentation
+++ a/mm/Kconfig
@@ -213,6 +213,8 @@ config UNEVICTABLE_LRU
 	  will use one page flag and increase the code size a little,
 	  say Y unless you know what you are doing.
 
+	  See Documentation/vm/unevictable-lru.txt for more information.
+
 config HAVE_MLOCK
 	bool
 	default y if MMU=y
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
mm-point-the-unevictable_lru-config-option-at-the-documentation.patch
mm-reformat-the-unevictable-lru-documentation.patch
frv-duplicate-output_buffer-of-e03.patch
flat-fix-data-sections-alignment.patch
mutex-subsystem-synchro-test-module.patch

