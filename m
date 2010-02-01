From: akpm@linux-foundation.org
Subject: [alternative-merged] doc-document-nopat-parameter.patch removed from -mm tree
Date: Mon, 01 Feb 2010 10:37:49 -0800
Message-ID: <201002011837.o11Ibn6t004844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755274Ab0BASiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 13:38:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     doc: document nopat parameter
has been removed from the -mm tree.  Its filename was
     doc-document-nopat-parameter.patch

This patch was dropped because an alternative patch was merged

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

