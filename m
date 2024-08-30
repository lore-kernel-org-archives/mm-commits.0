Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4221BE84B
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057491; cv=none; b=m5lOYf861G/lQbgJBKoHNfaGjw5hDiTmthLHUsNUpqyoyC3oUoXX4Y4lAIq6/ijyarA5HPIw10teBTXkYgEOBgZ2lndmccHY9p8U7OhUREQaV3kJiQIUPsI43eSzjzkDhfaXqqU4GICYAwSsqX0GEbMBKq919+Yt3GlWBIzpjKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057491; c=relaxed/simple;
	bh=UWEkjLY03MK7WJwyRczPpl6nUPXWCyuakFMtEGvDaD8=;
	h=Date:To:From:Subject:Message-Id; b=g+DY+gTeYoqoO+XodrMUDnB9wVVooGtBlEXXNS4KuMrLVs8TLbtU3d3jJsvNZqXl8YTE0TUNeVceDWHo/tE3XFlBb4gorW2M6rgjySZ6+g+Pdu/CzYfHxYNB8QcSX7dksj90eCmL0z9wKXB/OhEs8cAjHGuze4vzvBJoKOaeJJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0pK3bA2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0pK3bA2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD959C4CEC2;
	Fri, 30 Aug 2024 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725057489;
	bh=UWEkjLY03MK7WJwyRczPpl6nUPXWCyuakFMtEGvDaD8=;
	h=Date:To:From:Subject:From;
	b=0pK3bA2QmOFk2OTFazOsO8g+ns1I9HNyiY2waHMsW8rZd9/Qm+R0Dc892rTvdd4gt
	 yHlP/Umxte7NpvGawNPVrUOoBJsNOqqRCZE4awsdvjdx6xy+xYe874YsgFXcrCX179
	 RIQDls7uJI1x319Q9rte7x+qCdtXJpOwP67pPUdw=
Date: Fri, 30 Aug 2024 15:38:09 -0700
To: mm-commits@vger.kernel.org,matttbe@kernel.org,davem@davemloft.net,jankul@alatek.krakow.pl,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-jan-kuliga.patch added to mm-hotfixes-unstable branch
Message-Id: <20240830223809.CD959C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update entry for Jan Kuliga
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-entry-for-jan-kuliga.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-jan-kuliga.patch

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
From: Jan Kuliga <jankul@alatek.krakow.pl>
Subject: mailmap: update entry for Jan Kuliga
Date: Fri, 30 Aug 2024 11:56:58 +0200

Soon I won't be able to use my current email address.

Link: https://lkml.kernel.org/r/20240830095658.1203198-1-jankul@alatek.krakow.pl
Signed-off-by: Jan Kuliga <jankul@alatek.krakow.pl>
Cc: David S. Miller <davem@davemloft.net>
Cc: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-jan-kuliga
+++ a/.mailmap
@@ -269,6 +269,7 @@ James Ketrenos <jketreno@io.(none)>
 Jan Glauber <jan.glauber@gmail.com> <jang@de.ibm.com>
 Jan Glauber <jan.glauber@gmail.com> <jang@linux.vnet.ibm.com>
 Jan Glauber <jan.glauber@gmail.com> <jglauber@cavium.com>
+Jan Kuliga <jtkuliga.kdev@gmail.com> <jankul@alatek.krakow.pl>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@tuni.fi>
_

Patches currently in -mm which might be from jankul@alatek.krakow.pl are

mailmap-update-entry-for-jan-kuliga.patch

