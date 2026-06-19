Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241B5347BD9;
	Fri, 19 Jun 2026 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781892867; cv=none; b=erPjVnVgPgXvndiVlFO1z7mPy6hBaVfYTLWea2QmxGrD3UnLmMyczqFLRW8gOK5EXvwVazsjw58wfX0YbyDy5SZ4/NPvEUVHV5Tz8G+t4Q8uDqVmpzi/Mtf1ppXB1taxeWVW8cWeZ0Bpo/ilu75E3dEQeSAEqAxxTIbp1pM1fI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781892867; c=relaxed/simple;
	bh=h67BiLoZvO6j3vBezxMHfW927eFoKNwkdAYdymPqnX0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CqeFxFJH0xL/s7OI1AL+kCswEpM2pxK1BQRxlyn9uXeWkcnw/alnqGBNYNEiR2UkcOqGfYts3oAB1vIUIjc1F1OXE8H4aPV2ULnDv9AZLVlKEn4TlpJJpbPAr6MDnUxYcULMaorC2Z58c2T+tps0eJnQxtM42jsSyEwBeB/JvYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFG0dXDa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFG0dXDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD821F000E9;
	Fri, 19 Jun 2026 18:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781892865;
	bh=oqyIcGARJODplCSo9Kl2yV2cMuHVctJWhciqisobXCk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=QFG0dXDaaCxAZho2nbLoKbK3x5feeZuPKuTvYK7kAB3KsHAG+7mrNcVBfjgKXPox4
	 8UVAO5UnmnvI9XjiQbcgRRKZRX6quE6gKO/OkOJFbJYXDg3aSzw8RbSQbFAZRmDSfo
	 17suW1Gs5N1/j7qDBftvabYtKlr8tQ57OB+MvTh05OjxMOmvH1UQH21vdsjIqYfnQt
	 WeJrZdwqbS0OAAfYwPJI8oqqMIQPXhNtMdfdtROlFOzJuJjk2E3ty62HkcjwEqyqL1
	 g8BDakRtSy4a1U6IQuDKC27VhVbwGBC48Jg9zAypvim2MBGxM1OMz1ykcdAxWmNjCZ
	 9XEMod4t3RyXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BD53AAA0F2;
	Fri, 19 Jun 2026 18:14:19 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.2-rc1 (v2)
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260618093027.803700be945480575260b0f3@linux-foundation.org>
References: <20260618093027.803700be945480575260b0f3@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260618093027.803700be945480575260b0f3@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-18-09-26
X-PR-Tracked-Commit-Id: e3d8707358ea76b78bdec9928937bb9a797f2c8f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a552c81ff4a16738ca5a44a177d552eb38d552ce
Message-Id: <178189285848.4018353.4379775953714652811.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jun 2026 18:14:18 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Jun 2026 09:30:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-18-09-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a552c81ff4a16738ca5a44a177d552eb38d552ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
