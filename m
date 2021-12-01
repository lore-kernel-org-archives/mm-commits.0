Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F10AC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  1 Dec 2021 01:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346139AbhLABa6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Nov 2021 20:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhLABa6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Nov 2021 20:30:58 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDE5C061574
        for <mm-commits@vger.kernel.org>; Tue, 30 Nov 2021 17:27:37 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J3hKH3yLqz4xR7;
        Wed,  1 Dec 2021 12:27:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638322051;
        bh=TXCZF22YIkTuzB2PSdihVnNKkjkDyXW9RReqZlYpjwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AERyN4piVpYpuQwKQ0FTBPK6yvdv0YBqZai5VcjvLCkRzkrILcoAeP+SEDQENLiLU
         7ZR/gVuQ0EUz0zOP4esMK42/XJjq5bmzbIVSzfxzO3noe24hYOS+veestCFWDp3he+
         VaxpsrSjPSg5yPxrOpqb5AB7gZnNFcXvd3/bcsnkmyOAMEDJk1LLtVjEl4MbQVEW3H
         zdRZ1oEsyrvqzTM4Pp+x9uoaLb08GkgE3AWQYuwP8TLcLm0+nWO9LK4yu2lTU77sf7
         SnJhcwjDU6fyz6C7OVWofnHNEVQZ3hhVWZ52oMR8oYFpiaI9GSMZnKYsvxQkwsyyKQ
         l1d+18L6Zh4Qg==
Date:   Wed, 1 Dec 2021 12:27:28 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     lkp@intel.com, mcgrof@kernel.org, mm-commits@vger.kernel.org
Subject: Re: +
 firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch added
 to -mm tree
Message-ID: <20211201122728.3fd6463f@canb.auug.org.au>
In-Reply-To: <20211201000538.0GqUUdBdv%akpm@linux-foundation.org>
References: <20211201000538.0GqUUdBdv%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/pCIo=K/uzz=IY+s.fgRaL1e";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/pCIo=K/uzz=IY+s.fgRaL1e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 30 Nov 2021 16:05:38 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: firmware_loader-move-firmware-sysctl-to-its-own-files-fix-f=
ix
> has been added to the -mm tree.  Its filename is
>      firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/pCIo=K/uzz=IY+s.fgRaL1e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGmz4AACgkQAVBC80lX
0GyUfAf+Mh4jzk2giFMwqjWoUprAgc26JuxaV65JnD3T5GnTrEPLJdYwKd+KqdDb
hOBFoLDJsHyaszpox9ICFPanoLooWuadfx6DazGiDgBHcvgfDgYPS/N19R+7iKWs
GVN3cZA7FraEQtJ4YuS+tdU8UXv8rLpVPEaZnHla4vqHQGggVZDkBGUqiYHz8fmC
fy5Eul7t+wIQMHfC6wW/kitlFWxMuwea97Eywg/+P5J7S2he1LBxrFRaYT06bNKn
KJ4SjDjwC2R+MpjaX8SniSUy50AaJNIH+1J1VZqBAkazuBavxHsKjaQ417WpfR/A
ZLOPlV9uEaeQYJL3nMyfoXlF7c2djw==
=Sylf
-----END PGP SIGNATURE-----

--Sig_/pCIo=K/uzz=IY+s.fgRaL1e--
