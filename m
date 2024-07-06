Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D71313C3F7
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720291233; cv=none; b=WwwtChofpd7yzUufgrWes9EsVfEHutpUo46rKEaNw1TPWgC+xeDD7P++lHoY0veGNpeUd1LUYkP0H333Pu9dDGDISYOe2XGkOMBR3KCssXFoXCLhZJQDFPM3CtVdSyUOJQf5nXD5XeteObwZ7onODKIJbZoAW9rlpO9Dn0cH3AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720291233; c=relaxed/simple;
	bh=vNRvKKI0fGuuH3SZbAt2PRW/dmHLF8cdDJFEp2+saPY=;
	h=Date:To:From:Subject:Message-Id; b=Fwe9nMQim/ydaGZJWPU1smXy4RKYQMobuiCmBSz9TwhNYI8Wa9nenQ51hFOdm0ILYKzbmB9vzvbltxIsSN5jo3rb/7gzeKZHU2UDArzMRn3jhkWd58CNJL3Y3caRe/MlablRvdrxv/DQiIMEQg5/ZGYMfu9J/wNacydHv1u3Ows=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QFdXRhCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QFdXRhCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5ABC4AF0C;
	Sat,  6 Jul 2024 18:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720291232;
	bh=vNRvKKI0fGuuH3SZbAt2PRW/dmHLF8cdDJFEp2+saPY=;
	h=Date:To:From:Subject:From;
	b=QFdXRhCnzTp8PJUwYoQDpqHa7sYsQOtHSt4XxeGEXdI8ny5mqnWsLaTbpN1d//jXc
	 U8Ko6ZBVmBkR9TigJ26mpZ+Sh0tHBkBz6bg5RUviMdsxX33N7/ZgIxuJjppJTtcMpr
	 nnz6C/fzLuGf79C9EQzeUBb6cXlKe4cRFtb320i4=
Date: Sat, 06 Jul 2024 11:40:32 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-lorenzo-stoakess-email-address.patch removed from -mm tree
Message-Id: <20240706184032.BA5ABC4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mailmap: update Lorenzo Stoakes's email address
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-lorenzo-stoakess-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: mailmap: update Lorenzo Stoakes's email address
Date: Wed, 3 Jul 2024 10:27:04 +0100

Now working at Oracle.

Link: https://lkml.kernel.org/r/20240703092704.11571-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-update-lorenzo-stoakess-email-address
+++ a/.mailmap
@@ -384,6 +384,7 @@ Li Yang <leoyang.li@nxp.com> <leoli@free
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lior David <quic_liord@quicinc.com> <liord@codeaurora.org>
 Lorenzo Pieralisi <lpieralisi@kernel.org> <lorenzo.pieralisi@arm.com>
+Lorenzo Stoakes <lorenzo.stoakes@oracle.com> <lstoakes@gmail.com>
 Luca Ceresoli <luca.ceresoli@bootlin.com> <luca@lucaceresoli.net>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
 Luo Jie <quic_luoj@quicinc.com> <luoj@codeaurora.org>
--- a/MAINTAINERS~maintainers-mailmap-update-lorenzo-stoakess-email-address
+++ a/MAINTAINERS
@@ -14474,7 +14474,7 @@ MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
-R:	Lorenzo Stoakes <lstoakes@gmail.com>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


