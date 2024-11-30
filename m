Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0A63FC2
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732940284; cv=none; b=GIckVB6WC/t+c6kUwrSpyIki1exl773arSST13f5tGSk0vgrRjpioyFLrRYwSMEElGczt8Dbqk3hQ6+1loDT6OaMy7tEeKYGrihMpmeaPcrNE2cyBCLWShyMBf+JelCJcNh1oh+vw6SxmgYP9B6SNsFfaVEDXQKa22w4Vuy3Hs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732940284; c=relaxed/simple;
	bh=SoFOVBUSSVCSDu/IlISsFNXguljhc1xR/CJLl/Uj/os=;
	h=Date:To:From:Subject:Message-Id; b=OZdn7s4hE+eYn1glHmkXYNBDFn9u/Gfn63SJjzSJZ2EgY1ZKQGlsc4AqcbYFXyRwH3BGvc4tTKD0vwuwezowNUsUfPQlbAJpj7W/yT+4WxP6ZmciF2DZWQzOPpG+2KDiLe85vjwrQOgbOERfN7lSXMB8R/aMmeGqK9r79aOqyd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0PKWzLbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0PKWzLbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B19C4CECC;
	Sat, 30 Nov 2024 04:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732940283;
	bh=SoFOVBUSSVCSDu/IlISsFNXguljhc1xR/CJLl/Uj/os=;
	h=Date:To:From:Subject:From;
	b=0PKWzLbows5zBoRRf459Ib+qvicJH1orgSJelzD4+AyGWjJkTeKtE6ECA/6CkL/Tf
	 pHNiNTKJMrjCTN+LKdndGRVkZ1WCotlEvLe86eSuTRNyY0MQR/lbeXSFpSzjlPDJ5d
	 uA1LSeAdp2s0XHvPxJ4vNf88mxzFZa9AAOsGW8qM=
Date: Fri, 29 Nov 2024 20:18:03 -0800
To: mm-commits@vger.kernel.org,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch added to mm-nonmm-unstable branch
Message-Id: <20241130041803.B4B19C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: scripts/spelling.txt: add more spellings to spelling.txt
Date: Wed, 13 Nov 2024 10:21:06 +0000

Add some of the more common spelling mistakes and typos that I've found
while fixing up spelling mistakes in the kernel over the past year.

Link: https://lkml.kernel.org/r/20241113102106.1163050-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -222,6 +222,7 @@ autonymous||autonomous
 auxillary||auxiliary
 auxilliary||auxiliary
 avaiable||available
+avaialable||available
 avaible||available
 availabe||available
 availabled||available
@@ -267,6 +268,7 @@ broadcase||broadcast
 broadcat||broadcast
 bufer||buffer
 bufferred||buffered
+bufferur||buffer
 bufufer||buffer
 cacluated||calculated
 caculate||calculate
@@ -405,6 +407,7 @@ configutation||configuration
 congiuration||configuration
 conider||consider
 conjuction||conjunction
+connction||connection
 connecetd||connected
 connectinos||connections
 connetor||connector
@@ -413,6 +416,7 @@ connnections||connections
 consistancy||consistency
 consistant||consistent
 consits||consists
+constructred||constructed
 containes||contains
 containts||contains
 contaisn||contains
@@ -450,6 +454,7 @@ creationg||creating
 cryptocraphic||cryptographic
 cummulative||cumulative
 cunter||counter
+curent||current
 curently||currently
 cylic||cyclic
 dafault||default
@@ -461,6 +466,7 @@ decendant||descendant
 decendants||descendants
 decompres||decompress
 decsribed||described
+decrese||decrease
 decription||description
 detault||default
 dectected||detected
@@ -485,6 +491,7 @@ delare||declare
 delares||declares
 delaring||declaring
 delemiter||delimiter
+deley||delay
 delibrately||deliberately
 delievered||delivered
 demodualtor||demodulator
@@ -551,6 +558,7 @@ disgest||digest
 disired||desired
 dispalying||displaying
 dissable||disable
+dissapeared||disappeared
 diplay||display
 directon||direction
 direcly||directly
@@ -606,6 +614,7 @@ eigth||eight
 elementry||elementary
 eletronic||electronic
 embeded||embedded
+emtpy||empty
 enabledi||enabled
 enbale||enable
 enble||enable
@@ -723,10 +732,12 @@ followign||following
 followings||following
 follwing||following
 fonud||found
+forcebly||forcibly
 forseeable||foreseeable
 forse||force
 fortan||fortran
 forwardig||forwarding
+forwared||forwarded
 frambuffer||framebuffer
 framming||framing
 framwork||framework
@@ -767,6 +778,7 @@ grahpical||graphical
 granularty||granularity
 grapic||graphic
 grranted||granted
+grups||groups
 guage||gauge
 guarenteed||guaranteed
 guarentee||guarantee
@@ -780,6 +792,7 @@ hardare||hardware
 harware||hardware
 hardward||hardware
 havind||having
+heigth||height
 heirarchically||hierarchically
 heirarchy||hierarchy
 heirachy||hierarchy
@@ -788,9 +801,11 @@ hearbeat||heartbeat
 heterogenous||heterogeneous
 hexdecimal||hexadecimal
 hybernate||hibernate
+hiearchy||hierarchy
 hierachy||hierarchy
 hierarchie||hierarchy
 homogenous||homogeneous
+horizental||horizontal
 howver||however
 hsould||should
 hypervior||hypervisor
@@ -842,6 +857,7 @@ independed||independent
 indiate||indicate
 indicat||indicate
 inexpect||inexpected
+infalte||inflate
 inferface||interface
 infinit||infinite
 infomation||information
@@ -861,6 +877,7 @@ initators||initiators
 initialiazation||initialization
 initializationg||initialization
 initializiation||initialization
+initializtion||initialization
 initialze||initialize
 initialzed||initialized
 initialzing||initializing
@@ -877,6 +894,7 @@ instanciate||instantiate
 instanciated||instantiated
 instuments||instruments
 insufficent||insufficient
+intead||instead
 inteface||interface
 integreated||integrated
 integrety||integrity
@@ -1081,6 +1099,7 @@ notications||notifications
 notifcations||notifications
 notifed||notified
 notity||notify
+notfify||notify
 nubmer||number
 numebr||number
 numer||number
@@ -1122,6 +1141,7 @@ orientatied||orientated
 orientied||oriented
 orignal||original
 originial||original
+orphanded||orphaned
 otherise||otherwise
 ouput||output
 oustanding||outstanding
@@ -1184,9 +1204,11 @@ peroid||period
 persistance||persistence
 persistant||persistent
 phoneticly||phonetically
+pipline||pipeline
 plaform||platform
 plalform||platform
 platfoem||platform
+platfomr||platform
 platfrom||platform
 plattform||platform
 pleaes||please
@@ -1211,6 +1233,7 @@ preceeding||preceding
 preceed||precede
 precendence||precedence
 precission||precision
+predicition||prediction
 preemptable||preemptible
 prefered||preferred
 prefferably||preferably
@@ -1289,6 +1312,7 @@ querrying||querying
 queus||queues
 randomally||randomly
 raoming||roaming
+readyness||readiness
 reasearcher||researcher
 reasearchers||researchers
 reasearch||research
@@ -1305,8 +1329,10 @@ recieves||receives
 recieving||receiving
 recogniced||recognised
 recognizeable||recognizable
+recompte||recompute
 recommanded||recommended
 recyle||recycle
+redect||reject
 redircet||redirect
 redirectrion||redirection
 redundacy||redundancy
@@ -1314,6 +1340,7 @@ reename||rename
 refcounf||refcount
 refence||reference
 refered||referred
+referencce||reference
 referenace||reference
 refererence||reference
 refering||referring
@@ -1348,11 +1375,13 @@ replys||replies
 reponse||response
 representaion||representation
 repsonse||response
+reqested||requested
 reqeust||request
 reqister||register
 requed||requeued
 requestied||requested
 requiere||require
+requieres||requires
 requirment||requirement
 requred||required
 requried||required
@@ -1440,6 +1469,7 @@ sequencial||sequential
 serivce||service
 serveral||several
 servive||service
+sesion||session
 setts||sets
 settting||setting
 shapshot||snapshot
@@ -1602,11 +1632,13 @@ trys||tries
 thses||these
 tiggers||triggers
 tiggered||triggered
+tiggerring||triggering
 tipically||typically
 timeing||timing
 timming||timing
 timout||timeout
 tmis||this
+tolarance||tolerance
 toogle||toggle
 torerable||tolerable
 torlence||tolerance
@@ -1633,6 +1665,7 @@ trasfer||transfer
 trasmission||transmission
 trasmitter||transmitter
 treshold||threshold
+trigged||triggered
 triggerd||triggered
 trigerred||triggered
 trigerring||triggering
@@ -1648,6 +1681,7 @@ uknown||unknown
 usccess||success
 uncommited||uncommitted
 uncompatible||incompatible
+uncomressed||uncompressed
 unconditionaly||unconditionally
 undeflow||underflow
 undelying||underlying
@@ -1715,6 +1749,7 @@ utitity||utility
 utitlty||utility
 vaid||valid
 vaild||valid
+validationg||validating
 valide||valid
 variantions||variations
 varible||variable
@@ -1724,6 +1759,7 @@ verbse||verbose
 veify||verify
 verfication||verification
 veriosn||version
+versoin||version
 verisons||versions
 verison||version
 veritical||vertical
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

