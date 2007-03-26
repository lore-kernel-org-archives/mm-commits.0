From: akpm@linux-foundation.org
Subject: - drivers-char-ip2-i2ellisc-remove-unused-function.patch removed from -mm tree
Date: Sun, 25 Mar 2007 22:43:20 -0700
Message-ID: <200703260545.l2Q5jNj5012594@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45625 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbXCZFp0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 01:45:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/ip2/i2ellis.c remove unused function
has been removed from the -mm tree.  Its filename was
     drivers-char-ip2-i2ellisc-remove-unused-function.patch

This patch was dropped because it had testing failures

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

git-ia64.patch
git-input.patch
i386-irq-kill-irq-compression.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-char-ip2-i2ellisc-remove-unused-function.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
