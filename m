From: akpm@linux-foundation.org
Subject: + crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch added to -mm tree
Date: Wed, 18 Jan 2012 16:12:54 -0800
Message-ID: <20120119001255.229C810004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:48134 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab2ASAM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 19:12:56 -0500
Received: by ghbg20 with SMTP id g20so497461ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 16:12:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, djwong@us.ibm.com, linux@horizon.com, rpearson@systemfabricworks.com


The patch titled
     Subject: crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix
has been added to the -mm tree.  Its filename is
     crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix

fix typo, per George

Cc: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: George Spelvin <linux@horizon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/crc32.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/crc32.txt~crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix Documentation/crc32.txt
--- a/Documentation/crc32.txt~crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix
+++ a/Documentation/crc32.txt
@@ -29,8 +29,8 @@ is sent last.  And when appending a CRC 
 do it in the right order, matching the endianness.
 
 Just like with ordinary division, you proceed one digit (bit) at a time.
-Each step of the division, division, you take one more digit (bit) of the
-dividend and append it to the current remainder.  Then you figure out the
+Each step of the division you take one more digit (bit) of the dividend
+and append it to the current remainder.  Then you figure out the
 appropriate multiple of the divisor to subtract to being the remainder
 back into range.  In binary, this is easy - it has to be either 0 or 1,
 and to make the XOR cancel, it's just a copy of bit 32 of the remainder.
_
Subject: Subject: crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-warnings-regarding-enum-migrate_mode.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
audit-treat-s_id-as-an-untrusted-string.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

