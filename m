From: akpm@linux-foundation.org
Subject: + smaps-add-clear_refs-file-to-clear-reference-docs.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:10:01 -0800
Message-ID: <200702130710.l1D7A1O5024679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57126 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbXBMHKI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:10:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com


The patch titled
     smaps: add documentation for clear_refs
has been added to the -mm tree.  Its filename is
     smaps-add-clear_refs-file-to-clear-reference-docs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: smaps: add documentation for clear_refs
From: David Rientjes <rientjes@google.com>

Adds documentation for new /proc/pid/clear_refs file.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   31 +++++++++++++--------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff -puN Documentation/filesystems/proc.txt~smaps-add-clear_refs-file-to-clear-reference-docs Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~smaps-add-clear_refs-file-to-clear-reference-docs
+++ a/Documentation/filesystems/proc.txt
@@ -121,21 +121,22 @@ subdirectory has the entries listed in T
 
 Table 1-1: Process specific entries in /proc 
 ..............................................................................
- File    Content                                        
- cmdline Command line arguments                         
- cpu	 Current and last cpu in which it was executed		(2.4)(smp)
- cwd	 Link to the current working directory
- environ Values of environment variables      
- exe	 Link to the executable of this process
- fd      Directory, which contains all file descriptors 
- maps	 Memory maps to executables and library files		(2.4)
- mem     Memory held by this process                    
- root	 Link to the root directory of this process
- stat    Process status                                 
- statm   Process memory status information              
- status  Process status in human readable form          
- wchan   If CONFIG_KALLSYMS is set, a pre-decoded wchan
- smaps	 Extension based on maps, presenting the rss size for each mapped file
+ File		Content
+ clear_refs	Clears page referenced bits shown in smaps output
+ cmdline	Command line arguments
+ cpu		Current and last cpu in which it was executed	(2.4)(smp)
+ cwd		Link to the current working directory
+ environ	Values of environment variables
+ exe		Link to the executable of this process
+ fd		Directory, which contains all file descriptors
+ maps		Memory maps to executables and library files	(2.4)
+ mem		Memory held by this process
+ root		Link to the root directory of this process
+ stat		Process status
+ statm		Process memory status information
+ status		Process status in human readable form
+ wchan		If CONFIG_KALLSYMS is set, a pre-decoded wchan
+ smaps		Extension based on maps, the rss size for each mapped file
 ..............................................................................
 
 For example, to get the status information of a process, all you have to do is
_

Patches currently in -mm which might be from rientjes@google.com are

smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
