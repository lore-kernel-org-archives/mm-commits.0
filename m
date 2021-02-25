Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F9FC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE63164F7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhBYTOj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:14:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234354AbhBYTMD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:12:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C6C464F28;
        Thu, 25 Feb 2021 19:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280282;
        bh=KZFm4GgfjAnxcZMeCTFgYhDz2FoEYzRKh7fdi3wNo70=;
        h=Date:From:To:Subject:From;
        b=KkIgWEqJ+U4i+rtL4ulR35kL6GKzkc62Z9Jekrn1iTBbqsoBCtROs0VhxRZjzlyw5
         KCPAtHBWLrLC6BT3AagCJk6AaZOL+p8bsJUWJo/kpn+lz8pTEUoiBBCxvNIpdPeWSX
         irwqkeAim0NyYF/z/7/pfsAJO6a0gh9+D7J/0lps=
Date:   Thu, 25 Feb 2021 11:11:22 -0800
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  [merged]
 scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch removed from
 -mm tree
Message-ID: <20210225191122.qbBkz3NfQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: scripts/spelling.txt: add more spellings to spelling.txt

Here are some of the more common spelling mistakes and typos that I've
found while fixing up spelling mistakes in the kernel since September 2020

Link: https://lkml.kernel.org/r/20210210124318.55082-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -340,6 +340,7 @@ comppatible||compatible
 compres||compress
 compresion||compression
 comression||compression
+comunicate||communicate
 comunication||communication
 conbination||combination
 conditionaly||conditionally
@@ -467,6 +468,7 @@ developpment||development
 deveolpment||development
 devided||divided
 deviece||device
+devision||division
 diable||disable
 dicline||decline
 dictionnary||dictionary
@@ -480,6 +482,7 @@ difinition||definition
 digial||digital
 dimention||dimension
 dimesions||dimensions
+diconnected||disconnected
 disgest||digest
 dispalying||displaying
 diplay||display
@@ -519,6 +522,7 @@ downlads||downloads
 droped||dropped
 droput||dropout
 druing||during
+dyanmic||dynamic
 dynmaic||dynamic
 eanable||enable
 eanble||enable
@@ -543,6 +547,7 @@ encrupted||encrypted
 encrypiton||encryption
 encryptio||encryption
 endianess||endianness
+enpoint||endpoint
 enhaced||enhanced
 enlightnment||enlightenment
 enqueing||enqueuing
@@ -644,6 +649,7 @@ forwardig||forwarding
 frambuffer||framebuffer
 framming||framing
 framwork||framework
+frequence||frequency
 frequncy||frequency
 frequancy||frequency
 frome||from
@@ -686,10 +692,12 @@ handfull||handful
 hanlde||handle
 hanled||handled
 happend||happened
+hardare||hardware
 harware||hardware
 havind||having
 heirarchically||hierarchically
 helpfull||helpful
+heterogenous||heterogeneous
 hexdecimal||hexadecimal
 hybernate||hibernate
 hierachy||hierarchy
@@ -734,6 +742,7 @@ inconsistant||inconsistent
 increas||increase
 incremeted||incremented
 incrment||increment
+incuding||including
 inculde||include
 indendation||indentation
 indended||intended
@@ -744,6 +753,7 @@ indiate||indicate
 indicat||indicate
 inexpect||inexpected
 inferface||interface
+infinit||infinite
 infomation||information
 informatiom||information
 informations||information
@@ -774,6 +784,7 @@ instace||instance
 instal||install
 instanciate||instantiate
 instanciated||instantiated
+instuments||instruments
 insufficent||insufficient
 inteface||interface
 integreated||integrated
@@ -872,6 +883,7 @@ mailformed||malformed
 malplaced||misplaced
 malplace||misplace
 managable||manageable
+managament||management
 managment||management
 mangement||management
 manger||manager
@@ -890,6 +902,7 @@ meetign||meeting
 memeory||memory
 memmber||member
 memoery||memory
+memroy||memory
 ment||meant
 mergable||mergeable
 mesage||message
@@ -1003,6 +1016,7 @@ overlaping||overlapping
 overide||override
 overrided||overridden
 overriden||overridden
+overrrun||overrun
 overun||overrun
 overwritting||overwriting
 overwriten||overwritten
@@ -1039,6 +1053,7 @@ peforming||performing
 peice||piece
 pendantic||pedantic
 peprocessor||preprocessor
+perfomance||performance
 perfoming||performing
 perfomring||performing
 periperal||peripheral
@@ -1104,6 +1119,7 @@ prodecure||procedure
 progamming||programming
 progams||programs
 progess||progress
+programable||programmable
 programers||programmers
 programm||program
 programms||programs
@@ -1148,6 +1164,7 @@ recieved||received
 recieve||receive
 reciever||receiver
 recieves||receives
+recieving||receiving
 recogniced||recognised
 recognizeable||recognizable
 recommanded||recommended
@@ -1251,6 +1268,7 @@ searchs||searches
 secquence||sequence
 secund||second
 segement||segment
+seleted||selected
 semaphone||semaphore
 senario||scenario
 senarios||scenarios
@@ -1267,6 +1285,7 @@ seqeunce||sequence
 seqeuncer||sequencer
 seqeuencer||sequencer
 sequece||sequence
+sequemce||sequence
 sequencial||sequential
 serivce||service
 serveral||several
@@ -1337,6 +1356,7 @@ suble||subtle
 substract||subtract
 submited||submitted
 submition||submission
+succeded||succeeded
 suceed||succeed
 succesfully||successfully
 succesful||successful
@@ -1357,6 +1377,7 @@ supportin||supporting
 suppoted||supported
 suppported||supported
 suppport||support
+supprot||support
 supress||suppress
 surpressed||suppressed
 surpresses||suppresses
@@ -1405,6 +1426,7 @@ thresold||threshold
 throught||through
 trackling||tracking
 troughput||throughput
+trys||tries
 thses||these
 tiggers||triggers
 tiggered||triggered
@@ -1418,7 +1440,9 @@ traking||tracking
 tramsmitted||transmitted
 tramsmit||transmit
 tranasction||transaction
+tranceiver||transceiver
 tranfer||transfer
+tranmission||transmission
 transcevier||transceiver
 transciever||transceiver
 transferd||transferred
@@ -1472,6 +1496,7 @@ unnecesary||unnecessary
 unneedingly||unnecessarily
 unnsupported||unsupported
 unmached||unmatched
+unprecise||imprecise
 unregester||unregister
 unresgister||unregister
 unrgesiter||unregister
@@ -1507,6 +1532,7 @@ varient||variant
 vaule||value
 verbse||verbose
 veify||verify
+veriosn||version
 verisons||versions
 verison||version
 verson||version
_

Patches currently in -mm which might be from colin.king@canonical.com are


