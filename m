From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 009/118] scripts/spelling.txt: add more spellings
 to spelling.txt
Date: Thu, 30 Jan 2020 22:11:27 -0800
Message-ID: <20200131061127.46k3qQbsz%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGL2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:28 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris.paterson2@renesas.com, colin.king@canonical.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, paul.walmsley@sifive.com, sboyd@kernel.org, torvalds@linux-foundation.org, xndchn@gmail.com

From: Xiong <xndchn@gmail.com>
Subject: scripts/spelling.txt: add more spellings to spelling.txt

Here are some of the common spelling mistakes and typos that I've found
while fixing up spelling mistakes in the kernel.  Most of them still exist
in more than two source files.

Link: http://lkml.kernel.org/r/20191229143626.51238-1-xndchn@gmail.com
Signed-off-by: Xiong <xndchn@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Chris Paterson <chris.paterson2@renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -39,6 +39,8 @@ accout||account
 accquire||acquire
 accquired||acquired
 accross||across
+accumalate||accumulate
+accumalator||accumulator
 acessable||accessible
 acess||access
 acessing||accessing
@@ -106,6 +108,7 @@ alogrithm||algorithm
 alot||a lot
 alow||allow
 alows||allows
+alreay||already
 alredy||already
 altough||although
 alue||value
@@ -241,6 +244,7 @@ calender||calendar
 calescing||coalescing
 calle||called
 callibration||calibration
+callled||called
 calucate||calculate
 calulate||calculate
 cancelation||cancellation
@@ -311,6 +315,7 @@ compaibility||compatibility
 comparsion||comparison
 compatability||compatibility
 compatable||compatible
+compatibililty||compatibility
 compatibiliy||compatibility
 compatibilty||compatibility
 compatiblity||compatibility
@@ -330,6 +335,7 @@ comunication||communication
 conbination||combination
 conditionaly||conditionally
 conditon||condition
+condtion||condition
 conected||connected
 conector||connector
 connecetd||connected
@@ -388,6 +394,8 @@ dafault||default
 deafult||default
 deamon||daemon
 debouce||debounce
+decendant||descendant
+decendants||descendants
 decompres||decompress
 decsribed||described
 decription||description
@@ -411,11 +419,13 @@ delare||declare
 delares||declares
 delaring||declaring
 delemiter||delimiter
+delievered||delivered
 demodualtor||demodulator
 demension||dimension
 dependancies||dependencies
 dependancy||dependency
 dependant||dependent
+dependend||dependent
 depreacted||deprecated
 depreacte||deprecate
 desactivate||deactivate
@@ -995,6 +1005,7 @@ peice||piece
 pendantic||pedantic
 peprocessor||preprocessor
 perfoming||performing
+perfomring||performing
 peripherial||peripheral
 permissons||permissions
 peroid||period
@@ -1166,6 +1177,8 @@ retreive||retrieve
 retreiving||retrieving
 retrive||retrieve
 retrived||retrieved
+retrun||return
+retun||return
 retuned||returned
 reudce||reduce
 reuest||request
_
