From: akpm@linux-foundation.org
Subject: + drivers-char-ip2-i2ellisc-remove-unused-function.patch added to -mm tree
Date: Sun, 25 Mar 2007 14:29:09 -0800
Message-ID: <200703252229.l2PMT9JE004228@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32855 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbXCYW3L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 18:29:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com


The patch titled
     drivers/char/ip2/i2ellis.c remove unused function
has been added to the -mm tree.  Its filename is
     drivers-char-ip2-i2ellisc-remove-unused-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: drivers/char/ip2/i2ellis.c remove unused function
=46rom: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

drivers/char/ip2/i2ellis.c:108: warning: =E2=80=98iiEllisCleanup=E2=80=99=
 defined but not used

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/i2ellis.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN drivers/char/ip2/i2ellis.c~drivers-char-ip2-i2ellisc-remove-u=
nused-function drivers/char/ip2/i2ellis.c
--- a/drivers/char/ip2/i2ellis.c~drivers-char-ip2-i2ellisc-remove-unuse=
d-function
+++ a/drivers/char/ip2/i2ellis.c
@@ -93,23 +93,6 @@ iiEllisInit(void)
 }
=20
 //********************************************************************=
**********
-// Function:   iiEllisCleanup()
-// Parameters: None
-//
-// Returns:    Nothing
-//
-// Description:
-//
-// This routine performs any required cleanup of the iiEllis subsystem=
=2E
-//
-//********************************************************************=
**********
-static void
-iiEllisCleanup(void)
-{
-	kfree(pDelayTimer);
-}
-
-//********************************************************************=
**********
 // Function:   iiSetAddress(pB, address, delay)
 // Parameters: pB      - pointer to the board structure
 //             address - the purported I/O address of the board
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmai=
l.com are

origin.patch
git-ia64.patch
git-input.patch
i386-irq-kill-irq-compression.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-char-ip2-i2ellisc-remove-unused-function.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
