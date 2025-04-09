Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F1A250EC
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744162551; cv=none; b=kT+RjheaKjxek9QVhp7reu8PxscBhJ7CeZZRBrGvC//wfJGmXSstAi7Dsr4JRZS2qcSKGbwcJQY4LOpmd+/lM3BtssSSy6KQhptC8maSu4Rktd4FJhqhKjJqupycnA/K1Wyovzxu4rKPTH++C1LICVqUprEj4OsLCBa5zPNsCCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744162551; c=relaxed/simple;
	bh=UBshpcWP28D61SRZbh/58He+nG20gob5bxxh3UVhPAw=;
	h=Date:To:From:Subject:Message-Id; b=tWh1N//yK9a1kEcNVZgxIhLnakXw2Hm1MIRPP4JN7O1LnQ05Kv8kjPkJCTeGwvC38Z3ZUJN0RXheUp10pr0yMKELtOzkA4jWh8Im8bZKQZWvc9UKgjNx6ryzk7nFu6iqDHZECjEML3czcisYOq2laKRcjnCdYISybjuz3ItcNIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jY5lcyGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jY5lcyGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21CBC4CEE5;
	Wed,  9 Apr 2025 01:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744162550;
	bh=UBshpcWP28D61SRZbh/58He+nG20gob5bxxh3UVhPAw=;
	h=Date:To:From:Subject:From;
	b=jY5lcyGgEbN96FljW5FfL9eLLTBtp9xFSXyxTHjr7eCagzRYVU63+bvx93zYModDv
	 DUOi29Ba9d/jcUTkEHKeLrkYFK4Aku7+DdzhLFZe2ndQfS63ZFN94oiiuGFWks9YQN
	 uS1AwZFhzKNVRBbw9Uk7dP4h5EmyGc2/jShC5WRo=
Date: Tue, 08 Apr 2025 18:35:50 -0700
To: mm-commits@vger.kernel.org,laurent.pinchart@ideasonboard.com,jeanmichel.hautbois@yoseli.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-jean-michel-hautbois.patch added to mm-hotfixes-unstable branch
Message-Id: <20250409013550.B21CBC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Jean-Michel Hautbois
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-jean-michel-hautbois.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-jean-michel-hautbois.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Subject: mailmap: add entry for Jean-Michel Hautbois
Date: Fri, 28 Mar 2025 12:14:24 +0100

As recent contributions where made with the @ideasonboard.com email, any
reply would fail.  Add the proper address to map this old one.

Link: https://lkml.kernel.org/r/20250328-mailmap-v2-v2-1-bdc69d2193ca@yoseli.org
Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-jean-michel-hautbois
+++ a/.mailmap
@@ -322,6 +322,7 @@ Jayachandran C <c.jayachandran@gmail.com
 Jayachandran C <c.jayachandran@gmail.com> <jchandra@digeo.com>
 Jayachandran C <c.jayachandran@gmail.com> <jnair@caviumnetworks.com>
 <jean-philippe@linaro.org> <jean-philippe.brucker@arm.com>
+Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org> <jeanmichel.hautbois@ideasonboard.com>
 Jean Tourrilhes <jt@hpl.hp.com>
 Jeevan Shriram <quic_jshriram@quicinc.com> <jshriram@codeaurora.org>
 Jeff Garzik <jgarzik@pretzel.yyz.us>
_

Patches currently in -mm which might be from jeanmichel.hautbois@yoseli.org are

mailmap-add-entry-for-jean-michel-hautbois.patch

