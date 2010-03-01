From: akpm@linux-foundation.org
Subject: [merged] doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch removed from -mm tree
Date: Mon, 01 Mar 2010 11:47:05 -0800
Message-ID: <201003011947.o21Jl50K028725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293Ab0CATsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 14:48:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     doc: console doc should read "bind & unbind" instead of "bind & bind"
has been removed from the -mm tree.  Its filename was
     doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: console doc should read "bind & unbind" instead of "bind & bind"
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/console/console.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/console/console.txt~doc-console-doc-should-read-bind-unbind-instead-of-bind-bind Documentation/console/console.txt
--- a/Documentation/console/console.txt~doc-console-doc-should-read-bind-unbind-instead-of-bind-bind
+++ a/Documentation/console/console.txt
@@ -74,7 +74,7 @@ driver takes over the consoles vacated b
 hand, will bind the driver to the consoles that are currently occupied by a
 system driver.
 
-NOTE1: Binding and binding must be selected in Kconfig. It's under:
+NOTE1: Binding and unbinding must be selected in Kconfig. It's under:
 
 Device Drivers -> Character devices -> Support for binding and unbinding
 console drivers
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

origin.patch
linux-next.patch
thinkpad-acpi-make-driver-events-work-in-nvram-poll-mode.patch
eisa-fix-coding-style-for-eisa-bus-code.patch

