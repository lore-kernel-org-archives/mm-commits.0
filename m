From: akpm@linux-foundation.org
Subject: + remove-v850-from-linux-elf-emh.patch added to -mm tree
Date: Tue, 15 Mar 2016 14:24:39 -0700
Message-ID: <56e87d97.Y9DV/yOWCOluUa1r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcCOVYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:24:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Subject: include/uapi/linux/elf-em.h: remove v850
has been added to the -mm tree.  Its filename is
     remove-v850-from-linux-elf-emh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-v850-from-linux-elf-emh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/remove-v850-from-linux-elf-emh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Landley <rob@landley.net>
Subject: include/uapi/linux/elf-em.h: remove v850

The v850 port was removed by commits f606ddf42fd4 and 07a887d399b8 in
2008.  These #defines are not used in the current kernel.

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/elf-em.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/uapi/linux/elf-em.h~remove-v850-from-linux-elf-emh include/uapi/linux/elf-em.h
--- a/include/uapi/linux/elf-em.h~remove-v850-from-linux-elf-emh
+++ a/include/uapi/linux/elf-em.h
@@ -30,7 +30,6 @@
 #define EM_X86_64	62	/* AMD x86-64 */
 #define EM_S390		22	/* IBM S/390 */
 #define EM_CRIS		76	/* Axis Communications 32-bit embedded processor */
-#define EM_V850		87	/* NEC v850 */
 #define EM_M32R		88	/* Renesas M32R */
 #define EM_MN10300	89	/* Panasonic/MEI MN10300, AM33 */
 #define EM_OPENRISC     92     /* OpenRISC 32-bit embedded processor */
@@ -50,8 +49,6 @@
  */
 #define EM_ALPHA	0x9026
 
-/* Bogus old v850 magic number, used by old tools. */
-#define EM_CYGNUS_V850	0x9080
 /* Bogus old m32r magic number, used by old tools. */
 #define EM_CYGNUS_M32R	0x9041
 /* This is the old interim value for S/390 architecture */
_

Patches currently in -mm which might be from rob@landley.net are

remove-v850-from-linux-elf-emh.patch

