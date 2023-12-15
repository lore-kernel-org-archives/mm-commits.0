Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7B749F6F;
	Fri, 15 Dec 2023 20:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AyA359Pf"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6AB2FC433C8;
	Fri, 15 Dec 2023 20:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702670766;
	bh=oqwZb2gGqEO4njMrmpHf8tJxyxkuFGwxZ8VeePPgJW4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AyA359PfGF2Ym27TmeEC6kCeJVWd05Sa+6QXnq2sCDgVWFGtLvTxphV+hj2G+fFxj
	 F8ukfxeAN7p2Kl2I9s2l5MYk0jK8lLIk1FNr0XrrbmiJWaI4QdH7GTEkoDJzAJmtYO
	 QD2PjMQEVY4S5Y5tHYaNi3XkdYBP71lANJFGj2gBW6lFmVPxeZcBPLb4+IwlVletZN
	 RNUmdvPFc9bprX0gi3POOZyJG9csgQ9s3B9CswNDDDo1zXWrKfZIRh+DykepUweVmt
	 sYS0wBf/zUpRi46uxKjUBQYd+ApRh+WmG5hLzi95e42K+LCq+GFPVM05hL0uRStzG2
	 bAm97Zdghq3jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57FD6C4314C;
	Fri, 15 Dec 2023 20:06:06 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.7-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231215071604.946a433bbc05a6409faf5a33@linux-foundation.org>
References: <20231215071604.946a433bbc05a6409faf5a33@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231215071604.946a433bbc05a6409faf5a33@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-12-15-07-11
X-PR-Tracked-Commit-Id: 4376807bf2d5371c3e00080c972be568c3f8a7d1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a62aa88ba1a386e9b6953083b1ceb2fe027238b9
Message-Id: <170267076635.4828.14160018676561580247.pr-tracker-bot@kernel.org>
Date: Fri, 15 Dec 2023 20:06:06 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 15 Dec 2023 07:16:04 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-12-15-07-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a62aa88ba1a386e9b6953083b1ceb2fe027238b9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
