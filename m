From: akpm@linux-foundation.org
Subject: + doc-document-nopat-parameter.patch added to -mm tree
Date: Mon, 25 Jan 2010 14:55:30 -0800
Message-ID: <201001252255.o0PMtU6Z015922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727Ab0AYW4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 17:56:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     doc: document nopat parameter
has been added to the -mm tree.  Its filename is
     doc-document-nopat-parameter.patch

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
Subject: doc: document nopat parameter
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/kernel-parameters.txt~doc-document-nopat-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-document-nopat-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -1748,6 +1748,8 @@ and is between 256 and 4096 characters. 
 	nomfgpt		[X86-32] Disable Multi-Function General Purpose
 			Timer usage (for AMD Geode machines).
 
+	nopat		[X86] Disable PAT support
+
 	norandmaps	Don't use address space randomization.  Equivalent to
 			echo 0 > /proc/sys/kernel/randomize_va_space
 
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

linux-next.patch
doc-document-nopat-parameter.patch
eisa-fix-coding-style-for-eisa-bus-code.patch

