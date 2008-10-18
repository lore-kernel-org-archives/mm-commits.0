From: akpm@linux-foundation.org
Subject: - uvesafb-document-mode-to-mode_option-parameter-change.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:43 -0700
Message-ID: <200810182317.m9INHhaB029139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbYJRXRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpagano@gentoo.org, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     uvesafb: document mode to mode_option parameter change
has been removed from the -mm tree.  Its filename was
     uvesafb-document-mode-to-mode_option-parameter-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uvesafb: document mode to mode_option parameter change
From: Mike Pagano <mpagano@gentoo.org>

Document the change from the old "mode" parameter to the "mode_option"
parameter.

Signed-off-by: Mike Pagano <mpagano@gentoo.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/uvesafb.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/fb/uvesafb.txt~uvesafb-document-mode-to-mode_option-parameter-change Documentation/fb/uvesafb.txt
--- a/Documentation/fb/uvesafb.txt~uvesafb-document-mode-to-mode_option-parameter-change
+++ a/Documentation/fb/uvesafb.txt
@@ -52,7 +52,7 @@ are either given on the kernel command l
 
  video=uvesafb:1024x768-32,mtrr:3,ywrap (compiled into the kernel)
 
- # modprobe uvesafb mode=1024x768-32 mtrr=3 scroll=ywrap  (module)
+ # modprobe uvesafb mode_option=1024x768-32 mtrr=3 scroll=ywrap  (module)
 
 Accepted options:
 
@@ -105,7 +105,7 @@ vtotal:n
 <mode>  The mode you want to set, in the standard modedb format.  Refer to
         modedb.txt for a detailed description.  When uvesafb is compiled as
         a module, the mode string should be provided as a value of the
-        'mode' option.
+        'mode_option' option.
 
 vbemode:x
         Force the use of VBE mode x.  The mode will only be set if it's
_

Patches currently in -mm which might be from mpagano@gentoo.org are

origin.patch

